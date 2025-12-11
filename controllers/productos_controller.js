// controllers/productos_controller.js

// Importa el modelo de producto. Asegúrate que el nombre de archivo es 'Producto_model'
const Producto = require('../models/Producto');

/**
 * Función para obtener y listar todos los productos
 * Envía la lista de productos al frontend.
 * NOTA CRÍTICA: Se envía el nombre del archivo de imagen tal cual desde la BD.
 * Flutter será responsable de construir la URL completa (http://...) en el modelo Producto.dart.
 */
exports.listar = async (req, res) => {
  try {
    // 1. Obtiene la lista de productos de la base de datos
    const productos = await Producto.obtenerTodos(); // Contiene el campo imagen_producto = 'tilapia.jpg'

    // 2. Envía la lista de productos (con el nombre del archivo)
    // Se elimina la lógica de mapeo y concatenación de BASE_URL.
    res.status(200).json({
      success: true,
      data: productos // Envía la lista original (donde 'imagen_producto' es solo el nombre del archivo)
    });

  } catch (error) {
    // Captura cualquier error ocurrido en el modelo o en la BD
    console.error("❌ Error al obtener productos:", error);
    res.status(500).json({
      success: false,
      message: "Error en el servidor al listar productos",
      error: error.message
    });
  }
};