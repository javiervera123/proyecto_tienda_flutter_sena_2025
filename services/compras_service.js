// services/compras_service.js

const db = require("../config/db"); // Tu Pool de conexiones (PromisePool)

/**
 * Procesa la compra completa dentro de una transacción, actualizando pedidos,
 * stock y limpiando el carrito.
 * * @param {number} cliente_id - ID del cliente.
 * @param {Array<Object>} productos - Array de objetos [{producto_id, cantidad, precio_unitario}, ...]
 */
exports.procesarCompra = async (cliente_id, productos) => {
  // Obtener conexión dedicada para la transacción
  const conn = await db.getConnection();

  try {
    await conn.beginTransaction();
    console.log("-> Transacción de Compra iniciada.");

    // --- PASO 1: Calcular total de la compra ---
    const totalCompra = productos.reduce((sum, item) =>
        sum + (item.precio_unitario * item.cantidad),
    0);

    // Asumo que tienes una tabla 'pedidos' y 'pedido_detalle'
    // Si tus tablas se llaman 'compras' y 'compras_productos', deberás cambiar los nombres en las consultas.

    // --- PASO 2: Insertar el Encabezado del Pedido (Tabla 'pedidos') ---
    const [compraResult] = await conn.query(
      "INSERT INTO pedidos (cliente_id_pedido, fecha_pedido, total_pedido, estado_pedido) VALUES (?, NOW(), ?, 'PENDIENTE')",
      [cliente_id, totalCompra]
    );

    const pedido_id = compraResult.insertId;

    // --- PASO 3: Insertar Detalles y Gestionar Stock ---
    for (const item of productos) {

      // A. Verificar Stock con bloqueo de fila (FOR UPDATE)
      const [stockResult] = await conn.query(
        "SELECT stock_producto FROM productos WHERE id_producto = ? FOR UPDATE",
        [item.producto_id]
      );

      const productoData = stockResult[0];

      if (!productoData || productoData.stock_producto < item.cantidad) {
        // Lanza error y dispara el ROLLBACK
        throw new Error(`Stock insuficiente para producto ID: ${item.producto_id}. Cantidad solicitada: ${item.cantidad}.`);
      }

      // B. Descontar Stock
      await conn.query(
        "UPDATE productos SET stock_producto = stock_producto - ? WHERE id_producto = ?",
        [item.cantidad, item.producto_id]
      );

      // C. Insertar Detalle de Pedido (Tabla 'pedido_detalle')
      await conn.query(
        "INSERT INTO pedido_detalle (pedido_id, producto_id, cantidad, precio_unitario) VALUES (?, ?, ?, ?)",
        [pedido_id, item.producto_id, item.cantidad, item.precio_unitario]
      );
    }

    // --- PASO 4: Limpiar el Carrito (Tabla 'carrito_productos') ---
    // ESTE ES EL PASO CORREGIDO: Obtener el carrito_id primero.

    const [carritoResult] = await conn.query(
      "SELECT id FROM carrito WHERE cliente_id = ?",
      [cliente_id]
    );

    if (carritoResult.length > 0) {
        const carrito_id = carritoResult[0].id;

        // Eliminar los productos usando el ID REAL del carrito
        await conn.query(
          "DELETE FROM carrito_productos WHERE carrito_id = ?",
          [carrito_id]
        );
        console.log(`-> Carrito ID ${carrito_id} limpiado.`);
    }


    // --- PASO 5: COMMIT (Guardar todos los cambios) ---
    await conn.commit();
    console.log("-> COMMIT exitoso."); // ¡Este log ahora debería aparecer!

    return { success: true, pedido_id };

  } catch (error) {
    // --- PASO 6: ROLLBACK (Si algo falló, deshace todo) ---
    await conn.rollback();
    console.error("==========================================");
    console.error("❌ ERROR CRÍTICO EN TRANSACCIÓN:");
    console.error(error); // Muestra el error completo para depuración
    console.error("❌ Mensaje de Falla: ", error.message);
    console.error("==========================================");
    throw error;

  } finally {
    // --- PASO 7: LIBERAR CONEXIÓN (Clave para evitar bloqueos) ---
    if (conn) {
      conn.release();
      console.log("-> Conexión liberada al Pool.");
    }
  }
};


// ----------------------------------------------------------------------
// 🛒 LÓGICA DE OFERTAS (Inclusión solicitada previamente)
// ----------------------------------------------------------------------

exports.obtenerOfertasDelMes = async () => {
    try {
        const query = `
            SELECT
                p.id_producto,
                p.nombre_producto,
                p.descripcion_producto,
                p.precio_producto,
                p.imagen_producto,
                o.descuento_oferta,
                o.nombre_oferta
            FROM
                productos p
            INNER JOIN
                ofertas o ON p.id_producto = o.producto_id_oferta
            WHERE
                o.fecha_inicio_oferta <= CURDATE() AND o.fecha_fin_oferta >= CURDATE()
            ORDER BY o.descuento_oferta DESC;
        `;

        const [rows] = await db.execute(query);
        return rows;
    } catch (error) {
        console.error("❌ Error al obtener ofertas:", error);
        throw error;
    }
};