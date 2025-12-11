const express = require("express");
const router = express.Router();
const categoriasController = require("../controllers/categorias_controller");

// Obtener todas las categorías
router.get("/", categoriasController.getCategorias);

// Obtener una categoría por id
router.get("/:id", categoriasController.getCategoria);

// Crear categoría
router.post("/", categoriasController.createCategoria);

// Actualizar categoría
router.put("/:id", categoriasController.updateCategoria);

// Eliminar categoría
router.delete("/:id", categoriasController.deleteCategoria);

module.exports = router;
