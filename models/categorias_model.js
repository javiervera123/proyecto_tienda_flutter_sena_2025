const db = require("../config/db");

const Categoria = {
  getAll: async () => {
    try {
      const [results] = await db.query("SELECT * FROM categorias");
      return results;
    } catch (err) {
      throw err;
    }
  },

  getById: async (id) => {
    try {
      const [results] = await db.query(
        "SELECT * FROM categorias WHERE id_categoria = ?",
        [id]
      );
      return results[0];
    } catch (err) {
      throw err;
    }
  },

  create: async (data) => {
    try {
      const [result] = await db.query("INSERT INTO categorias SET ?", data);
      return { id: result.insertId, ...data };
    } catch (err) {
      throw err;
    }
  },

  update: async (id, data) => {
    try {
      await db.query("UPDATE categorias SET ? WHERE id_categoria = ?", [data, id]);
      return { id, ...data };
    } catch (err) {
      throw err;
    }
  },

  delete: async (id) => {
    try {
      await db.query("DELETE FROM categorias WHERE id_categoria = ?", [id]);
      return true;
    } catch (err) {
      throw err;
    }
  },
};

module.exports = Categoria;
