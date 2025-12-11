// models/carrito_model.js

// Importar el pool de conexiones (PromisePool de mysql2)
const db = require('../config/db');

// -------------------------------------------------------------
// FUNCIONES PRIVADAS (Auxiliares)
// -------------------------------------------------------------

/**
 * Función auxiliar para obtener el ID real del carrito a partir del ID del cliente.
 * @param {number} clienteId - El ID del cliente logeado.
 * @returns {Promise<number>} El ID del carrito.
 * @throws {Error} Si el carrito no se encuentra.
 */
async function getCarritoIdByClienteId(clienteId) {
    const [carritoResult] = await db.execute(
        "SELECT id FROM carrito WHERE cliente_id = ?",
        [clienteId]
    );

    if (carritoResult.length === 0) {
        throw new Error(`Carrito no encontrado para el cliente ID: ${clienteId}`);
    }

    return carritoResult[0].id;
}


// -------------------------------------------------------------
// EXPORTS (Funciones Públicas del Modelo)
// -------------------------------------------------------------

module.exports = {

    // ============================================
    // 📌 1. Obtener los productos del carrito
    // ============================================
    // Nota: El controlador recibe el carrito_id, por lo que no es necesario el mapeo aquí.
    getCarrito: async (carritoId) => {
        try {
            const query = `
                SELECT
                    cd.producto_id,
                    cd.cantidad,
                    p.nombre_producto,
                    p.precio_producto,
                    p.imagen_producto
                FROM carrito_detalle cd
                JOIN productos p ON cd.producto_id = p.id_producto
                WHERE cd.carrito_id = ?
            `;

            const [rows] = await db.execute(query, [carritoId]);

            console.log(`DEBUG: Productos encontrados en carrito #${carritoId}: ${rows.length}`);
            return rows;
        } catch (error) {
            console.error("❌ Error en el modelo getCarrito:", error);
            throw error;
        }
    },

    // ============================================
    // 📌 2. Agregar/Añadir un producto al carrito (CORREGIDO)
    // ============================================
    // El controlador llama con clienteId (enviado desde Flutter como 'carrito_id' en el body)
    addProducto: async (clienteId, productoId, cantidad) => {

        // 1. Obtener el ID real del carrito
        const carritoId = await getCarritoIdByClienteId(clienteId);

        // 2. Inicia la transacción para asegurar atomicidad
        const conn = await db.getConnection();
        try {
            await conn.beginTransaction();

            // 3. Verificar si el producto ya está en el carrito
            const [existe] = await conn.execute(
                "SELECT cantidad FROM carrito_detalle WHERE carrito_id = ? AND producto_id = ?",
                [carritoId, productoId]
            );

            if (existe.length > 0) {
                // 4. Si existe, actualizar la cantidad
                const nuevaCantidad = existe[0].cantidad + cantidad;
                await conn.execute(
                    "UPDATE carrito_detalle SET cantidad = ? WHERE carrito_id = ? AND producto_id = ?",
                    [nuevaCantidad, carritoId, productoId]
                );
            } else {
                // 5. Si no existe, insertar
                await conn.execute(
                    "INSERT INTO carrito_detalle (carrito_id, producto_id, cantidad) VALUES (?, ?, ?)",
                    [carritoId, productoId, cantidad]
                );
            }

            await conn.commit();
            return { success: true, carritoId: carritoId };
        } catch (error) {
            await conn.rollback();
            console.error("❌ Error en el modelo addProducto (ROLLBACK):", error);
            throw error;
        } finally {
            if (conn) conn.release();
        }
    },

    // ============================================
    // 📌 3. Actualizar cantidad de un producto
    // ============================================
    // El controlador llama con el carrito_id
    updateCantidad: async (carritoId, productoId, nuevaCantidad) => {
        // Si la nueva cantidad es 0, llamamos a la función de eliminación.
        if (nuevaCantidad <= 0) {
            return module.exports.deleteProducto(carritoId, productoId);
        }

        try {
            const [result] = await db.execute(
                "UPDATE carrito_detalle SET cantidad = ? WHERE carrito_id = ? AND producto_id = ?",
                [nuevaCantidad, carritoId, productoId]
            );
            return result;
        } catch (error) {
            console.error("❌ Error en el modelo updateCantidad:", error);
            throw error;
        }
    },

    // ============================================
    // 📌 4. Eliminar un producto del carrito
    // ============================================
    // El controlador llama con el carrito_id
    deleteProducto: async (carritoId, productoId) => {
        try {
            const [result] = await db.execute(
                "DELETE FROM carrito_detalle WHERE carrito_id = ? AND producto_id = ?",
                [carritoId, productoId]
            );
            return result;
        } catch (error) {
            console.error("❌ Error en el modelo deleteProducto:", error);
            throw error;
        }
    }
};