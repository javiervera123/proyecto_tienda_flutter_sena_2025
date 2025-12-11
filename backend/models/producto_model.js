const db = require("../config/db");

const Producto = {
  obtenerTodos: async () => {
    try {
    console.log("DEBUG: Ejecutando SELECT * FROM productos");
      const [results] = await db.query("SELECT * FROM productos");
      console.log("DEBUG: Resultados de productos (Length):", results.length);
      return results;
    } catch (err) {
      throw err;
    }
  },

  obtenerPorId: async (id) => {
    try {
      const [results] = await db.query(
        "SELECT * FROM productos WHERE id_producto = ?",
        [id]
      );
      return results[0];
    } catch (err) {
      throw err;
    }
  },

  crear: async (data) => {
    try {
      const [result] = await db.query("INSERT INTO productos SET ?", data);
      return { id: result.insertId, ...data };
    } catch (err) {
      throw err;
    }
  },

  actualizar: async (id, data) => {
    try {
      await db.query("UPDATE productos SET ? WHERE id_producto = ?", [data, id]);
      return { id, ...data };
    } catch (err) {
      throw err;
    }
  },

  eliminar: async (id) => {
    try {
      await db.query("DELETE FROM productos WHERE id_producto = ?", [id]);
      return true;
    } catch (err) {
      throw err;
    }
  },
};

module.exports = Producto;
