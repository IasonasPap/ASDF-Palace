const sql = require('mssql/msnodesqlv8');
const config = require("./db.config")

const pool = new sql.ConnectionPool(config)
module.exports = pool;