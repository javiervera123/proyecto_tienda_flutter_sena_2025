// Yo importo express para crear un enrutador (router) y definir rutas.
const express = require('express');

// Yo creo el router que contiene todas las rutas del carrito.
const router = express.Router();

// Yo importo el controlador que tiene la lógica (get, add, update, delete).
const carritoController = require('../controllers/carrito_controller');

// ------------------------------------------------------------
// RUTA: obtener productos del carrito por id de carrito
// Método: GET
// Ejemplo: GET /carrito/5
// ------------------------------------------------------------
// Yo defino una ruta GET que recibe el id del carrito por params
// y llamo a carritoController.getCarritoById para manejar la petición.
router.get('/:carrito_id', carritoController.getCarrito);


// ------------------------------------------------------------
// RUTA: agregar producto al carrito
// Método: POST
// Ejemplo: POST /carrito/add  { carrito_id, producto_id, cantidad }
// ------------------------------------------------------------
// Yo defino una ruta POST en /add que espera un body con carrito_id,
// producto_id y cantidad; la petición la procesa carritoController.addProducto.
router.post('/add', carritoController.addProducto);

// ------------------------------------------------------------
// RUTA: actualizar cantidad de producto en el carrito
// Método: PUT
// Ejemplo: PUT /carrito/update  { carrito_id, producto_id, cantidad }
// ------------------------------------------------------------
// Yo defino una ruta PUT en /update que recibe en el body los datos
// necesarios para cambiar la cantidad y llamo a carritoController.updateCantidad.
router.put('/update', carritoController.updateCantidad);

// ------------------------------------------------------------
// RUTA: eliminar producto del carrito
// Método: DELETE
// Ejemplo: DELETE /carrito/5/2  (carrito_id = 5, producto_id = 2)
// ------------------------------------------------------------
// Yo defino una ruta DELETE que recibe carrito_id y producto_id por params
// y delega la eliminación al carritoController.deleteProducto.
router.delete('/:carrito_id/:producto_id', carritoController.deleteProducto);

// ------------------------------------------------------------
// Yo exporto el router para que server.js lo use con app.use('/carrito', router)
// ------------------------------------------------------------
module.exports = router;
