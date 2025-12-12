const mysql = require("mysql2/promise");

// 1. Definimos la URL de conexión principal que debe usar Railway
const connectionUrl = "mysql://root:nJptHEktCgWeWmZKabkNfMYuQDOBUvsm@mysql.railway.internal:3306/railway";
//
const pool = mysql.createPool(connectionUrl ? connectionUrl : {
    // Si MYSQL_URL existe, úsala. Si no existe, usa los 5 parámetros individuales.
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