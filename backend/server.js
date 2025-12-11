// server.js

// Yo importo express para crear el servidor
const express = require("express");
const app = express();

// Yo importo cors para permitir solicitudes desde Flutter
const cors = require("cors");
const path = require('path'); //  IMPORTACIÓN NECESARIA!

// Yo importo la conexión a MySQL (el PromisePool)
const db = require("./config/db");

// ---------------------------
// 🔧 MIDDLEWARES
// ---------------------------
app.use(cors());
app.use(express.json()); // Permite recibir JSON en el body


//  PARA IMÁGENES o archivos estáticos(404)
// Yo configuro la carpeta 'uploads' para que sea accesible públicamente.
// Ahora, http://10.0.2.2:3000/uploads/...
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
// ---------------------------
// RUTAS
// ---------------------------

// Importa y usa todas las rutas
const productosRoutes = require("./routes/productos_routes");
app.use("/productos", productosRoutes);

const categoriasRoutes = require("./routes/categorias_routes");
app.use("/categorias", categoriasRoutes);

const carritoRoutes = require("./routes/carrito_routes");
app.use("/carrito", carritoRoutes);

const compraRoutes = require('./routes/compras_routes');
app.use('/compras', compraRoutes);
// ruta de las ofertas
//const ofertasRoutes = require('./routes/ofertas_routes');
//app.use('/ofertas', ofertasRoutes);

// ---------------------------
// LOGIN DIRECTO EN SERVER (CORREGIDO)
// ---------------------------

// Se añade 'async' para poder usar 'await' dentro de la función.
app.post("/login", async (req, res) => {
  const { username_credenciales, password_credenciales } = req.body;

  const sql = `
    SELECT *
    FROM credenciales
    WHERE username_credenciales = ? AND password_credenciales = ?
  `;

  try {
    // CORRECCIÓN: Usamos await para esperar la promesa, en lugar de un callback.
    const [resultado] = await db.query(sql, [username_credenciales, password_credenciales]);

    if (resultado.length > 0) {
      // Login exitoso
      res.json({ success: true, user: resultado[0] });
    } else {
      // Usuario no encontrado
      res.json({ success: false, message: "Usuario o contraseña incorrectos" });
    }

  } catch (err) {
    // Error en la BD
    console.error("Error SQL en login:", err);
    res.status(500).json({
      success: false,
      message: "Error en el servidor durante el login",
      error: err.message
    });
  }
});
// inicia servidor en railway
const PORT = process.env.PORT || 3000; // Usa el puerto que da Railway

app.listen(PORT, () => {
  console.log("Servidor corriendo en el puerto " + PORT);
});


/*INICIAR SERVIDOR en local

app.listen(3000, () => {
  console.log("Servidor corriendo en el puerto 3000");
});
*/