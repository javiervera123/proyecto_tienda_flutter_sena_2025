/*const express = require("express");
const router = express.Router();
const db = require("../config/db");

// LOGIN
router.post("/login", (req, res) => {
  console.log("BODY RECIBIDO:", req.body);

  const { usuario, password } = req.body;

  db.query(
    "SELECT * FROM credenciales WHERE usuario = ? AND password = ?",
    [usuario, password],
    (err, resultado) => {

      if (err) {
        return res.json({
          success: false,
          message: "Error en el servidor",
          error: err
        });
      }

      if (resultado.length > 0) {
        res.json({
          success: true,
          user: resultado[0]
        });
      } else {
        res.json({
          success: false,
          message: "Usuario o contraseña incorrectos"
        });
      }
    }
  );
});

module.exports = router;
*/