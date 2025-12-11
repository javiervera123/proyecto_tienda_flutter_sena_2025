const express = require("express");
const router = express.Router();

// Yo importo el controlador
const compraController = require("../controllers/compras_controller");

//Aqui van los endpoints
// RUTA: CONFIRMAR COMPRA
// Método: POST
// URL: /compras/confirmar
// ------------------------------------------------------------
router.post("/confirmar", compraController.confirmarCompra);
// endpoint prueba
router.get("/test", (req, res) => {
  res.json({ ok: true, msg: "Compras funcionando" });
});


module.exports = router;
