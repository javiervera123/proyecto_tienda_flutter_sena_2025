const mysql = require("mysql2/promise");

// 1. Definimos la URL de conexión principal que debe usar Railway
const connectionUrl = process.env.MYSQL_URL;

const pool = mysql.createPool(connectionUrl ? connectionUrl : {
    // 2. Si la URL falla (o no está definida), usamos los parámetros separados (como respaldo)
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