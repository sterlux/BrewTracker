const { Pool } = require("pg");

const pool = new Pool({
  user: process.env.DB_USER || "brewmaster",
  host: process.env.DB_HOST || "localhost",
  database: process.env.DB_NAME || "homebrewing",
  password: process.env.DB_PASSWORD || "brewpass123",
  port: process.env.DB_PORT || 5432,
});

pool.query("SELECT NOW()", (err, res) => {
  if (err) {
    console.error("Error connecting to db :(", err);
  } else {
    console.log("Connected to db :)");
  }
});

module.exports = {
  query: (text, params) => pool.query(text, params),
};
