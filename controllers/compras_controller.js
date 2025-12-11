// controllers/compras_controller.js

// Importa el servicio donde reside la lógica de la transacción (BD)
const compraService = require('../services/compras_service');

/**
 * Función principal para confirmar una compra desde el carrito
 * Recibe el ID del cliente y la lista de productos comprados desde Flutter.
 */
exports.confirmarCompra = async (req, res) => {
  // 1. Extrae el ID del cliente y el array de productos del cuerpo de la solicitud
  const { cliente_id, productos } = req.body;

  // 2. Validación básica de entrada
  if (!cliente_id || !productos || productos.length === 0) {
    return res.status(400).json({
      success: false,
      message: "ID del cliente y una lista de productos no vacía son requeridos para la compra."
    });
  }

  try {
    // 3. Llama al servicio, pasándole los datos necesarios
    const resultado = await compraService.procesarCompra(cliente_id, productos);

    // 4. Respuesta exitosa (si el servicio ejecutó el COMMIT)
    res.status(201).json({
      success: true,
      message: "Compra y stock actualizados con éxito",
      pedido_id: resultado.pedido_id
    });

  } catch (error) {
    // 5. Manejo de errores

    // Si el error es por stock (error de negocio), devuelve 400 (Bad Request)
    const isClientError = error.message.includes("Stock");
    const statusCode = isClientError ? 400 : 500;

    console.error("❌ Error al confirmar compra (Rollback):", error.message);

    res.status(statusCode).json({
      success: false,
      // Devuelve el mensaje de error exacto del servicio (ej. "Stock insuficiente")
      message: error.message
    });
  }
};