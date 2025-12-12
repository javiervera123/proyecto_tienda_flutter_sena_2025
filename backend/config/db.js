const mysql = require("mysql2/promise");

// Forzamos el uso de los 5 parámetros individuales (eliminamos la lógica del connectionUrl)
const pool = mysql.createPool({
    // Usaremos las variables de entorno para una carga limpia
    host: process.env.MYSQLHOST,
    user: process.env.MYSQLUSER,
    password: process.env.MYSQLPASSWORD,
    database: process.env.MYSQLDATABASE,
    port: process.env.MYSQLPORT,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

module.exports = pool;