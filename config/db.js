const mysql = require("mysql2/promise");

const pool = mysql.createPool({
    host: process.env.MYSQLHOST,                  //"localhost",  // cuando la bd es local
    user: process.env.MYSQLUSER,                  //"root",
    password: password: process.env.MYSQLPASSWORD,  //"root"
    database: process.env.MYSQLDATABASE,            // "db_tienda_online",
    port: process.env.MYSQLPORT                     //3306,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

module.exports = pool;
