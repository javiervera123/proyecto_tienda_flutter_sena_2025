// controllers/carrito_controller.js

// Importo el modelo del carrito, esperando que use async/await
const carritoModel = require('../models/carrito_model');

// Yo exporto todas las funciones del controlador dentro de un objeto
module.exports = {

  // ============================================
  // 📌 1. Obtener los productos del carrito
  // ============================================
  getCarrito: async (req, res) => { // ¡FUNCIÓN AHORA ES ASYNC!
    // Yo recibo el ID del carrito desde los parámetros de la URL
    const { carrito_id } = req.params;

    try {
      // Yo llamo al modelo y ESPERO (await) la promesa de los resultados
      const carrito = await carritoModel.getCarrito(carrito_id);

      // Si todo sale bien, yo envío los datos al cliente
      res.json({
        success: true,
        carrito: carrito
      });

    } catch (error) {
      // Si ocurre un error (ej. conexión o SQL), yo lo muestro en consola
      console.error("❌ Error al obtener carrito:", error);

      // Y respondo al cliente con un error 500
      return res.status(500).json({
        success: false,
        error: "Error al obtener el carrito: " + error.message
      });
    }
  },


  //  2. Agregar un producto al carrito

  addProducto: async (req, res) => { // ¡FUNCIÓN AHORA ES ASYNC!
    // recibo los datos enviados por Flutter o Postman
    const { cliente_id, producto_id, cantidad } = req.body;

    try {
      //llamo al modelo para insertar/actualizar y ESPERO el resultado
      const result = await carritoModel.addProducto(carrito_id, producto_id, cantidad);

      // respondo con éxito y los datos de la operación
      res.json({
        success: true,
        message: "Producto agregado correctamente",
        insertId: result.insertId // El modelo debe devolver el insertId o un objeto de éxito
      });

    } catch (error) {
      console.error(" Error al agregar producto:", error);
      return res.status(500).json({
        success: false,
        error: "Error al agregar producto al carrito: " + error.message
      });
    }
  },

  // ============================================
  // 📌 3. Actualizar cantidad de un producto
  // ============================================
  updateCantidad: async (req, res) => { // ¡FUNCIÓN AHORA ES ASYNC!
    const { carrito_id, producto_id, cantidad } = req.body;

    try {
      // Yo llamo al modelo para actualizar y ESPERO el resultado
      await carritoModel.updateCantidad(carrito_id, producto_id, cantidad);

      res.json({
        success: true,
        message: "Cantidad actualizada correctamente"
      });

    } catch (error) {
      console.error("Error al actualizar cantidad:", error);
      return res.status(500).json({
        success: false,
        error: "Error al actualizar cantidad: " + error.message
      });
    }
  },

  // ============================================
  //  Eliminar un producto del carrito
  // ============================================
  deleteProducto: async (req, res) => { // ¡FUNCIÓN AHORA ES ASYNC!
    const { carrito_id, producto_id } = req.params;

    try {
      // Yo llamo al modelo para eliminar y ESPERO el resultado
      await carritoModel.deleteProducto(carrito_id, producto_id);

      res.json({
        success: true,
        message: "Producto eliminado correctamente"
      });

    } catch (error) {
      console.error("❌ Error al eliminar producto:", error);
      return res.status(500).json({
        success: false,
        error: "Error al eliminar producto del carrito: " + error.message
      });
    }
  }
};