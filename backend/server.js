require("dotenv").config();
const express = require("express");
const cors = require("cors");
const db = require("./db");
const app = express();

app.use(cors());
app.use(express.json());

// Get all recipes from databse
app.get("/api/recipes", async (req, res) => {
  try {
    const results = await db.query(
      "SELECT * FROM recipes ORDER BY created_at DESC"
    );
    res.status(200).json({
      status: "success",
      results: results.rows.length,
      data: {
        recipes: results.rows,
      },
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ error: "Server error" });
  }
});

const PORT = process.env.PORT || 5002;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
