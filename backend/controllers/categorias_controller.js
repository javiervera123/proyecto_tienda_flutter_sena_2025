const Categoria = require("../models/categorias_model");

exports.getCategorias = async (req, res) => {
  try {
    const categorias = await Categoria.getAll(); // ← usado correctamente

    res.json(categorias);
  } catch (error) {
    console.error("Error al obtener categorías:", error);
    res.status(500).json({ error: "Error al obtener categorías" });
  }
};
exports.getCategoria = async (req, res) => {
  try {
    const data = await Categoria.getById(req.params.id);
    res.json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

exports.createCategoria = async (req, res) => {
  try {
    const data = await Categoria.create(req.body);
    res.json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

exports.updateCategoria = async (req, res) => {
  try {
    const data = await Categoria.update(req.params.id, req.body);
    res.json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

exports.deleteCategoria = async (req, res) => {
  try {
    await Categoria.delete(req.params.id);
    res.json({ msg: "Categoría eliminada" });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
