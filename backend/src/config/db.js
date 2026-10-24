const mysql = require('mysql2');
require('dotenv').config();

const useSSL = process.env.DB_SSL === 'true';

const db = mysql.createPool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  enableKeepAlive: true,
  keepAliveInitialDelay: 0,
  ...(useSSL ? { ssl: { rejectUnauthorized: false } } : {})
});

db.getConnection((err, conn) => {
  if (err) {
    console.error('Database connection failed:', err.code, err.message);
    return;
  }
  console.log('MySQL Database connected successfully!');
  conn.release();
});

module.exports = db;