import express from "express";
import cors from "cors";
import parseFile from "./parser/parse.js";
import fs from "fs";
import {
  initializeDatabase,
  insertAllData,
  createNewTable,
  checkIfDataExistsOnTable,
} from "./parser/db.js";

const app = express();
app.use(cors({ origin: "*" }));
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.get("/parseExcelToJSON", (req, res) => {
  var arr = parseFile("parser/feat_list.xlsx");
  fs.writeFileSync("parser/feat_list.json", JSON.stringify(arr));
  res.status(200).send({
    "status-code": 200,
    "message": "data parsed successfully",
    "data": arr
});
});

app.get("/get", async (req, res) => {
  try {
    const data = await knexClient("intakeqa").select("*");
    res.send(data);
  } catch (err) {
    console.error("❌ Error fetching data:", err);
    res.status(500).send("An error occurred while fetching data.");
  }
});

app.get("/createTableFromJson", async (req, res) => {
  try {
    fs.readFile("parser/feat_list.json", "utf8", async (error, data) => {
      if (error) {
        console.error("❌ Error reading JSON file:", error);
        res.status(500).send("An error occurred while reading the JSON file.");
        return;
      }

      const arr_json = JSON.parse(data);

      try {
        await createNewTable("intakeqa", arr_json);
        res.status(200).send("Table created successfully.");
      } catch (err) {
        console.error("❌ Error creating table:", err);
        res.status(500).send("An error occurred while creating the table.");
      }
    });
  } catch (err) {
    console.error("❌ Error creating table:", err);
    res.status(500).send("An error occurred while creating the table.");
  }
});

app.get("/insertIfNotExists", async (req, res) => {
  try {
    fs.readFile("parser/feat_list.json", "utf8", async (error, data) => {
      if (error) {
        console.error("❌ Error reading JSON file:", error);
        res.status(500).send("An error occurred while reading the JSON file.");
        return;
      }

      const arr_json = JSON.parse(data);

      try {
        const exist = await checkIfDataExistsOnTable("intakeqa");
        if (exist) {
          res.status(200).send("Data already exists.");
          return;
        } else {
          await insertAllData("intakeqa", arr_json);
          res.status(200).send("Data inserted successfully.");
        }
      } catch (err) {
        console.error("❌ Error inserting data:", err);
        res.status(500).send("An error occurred while inserting data.");
      }
    });
  } catch (err) {
    console.error("❌ Error inserting data:", err);
    res.status(500).send("An error occurred while inserting data.");
  }
});

app.post("/addColumn", async (req, res) => {
  try {
    await knexClient.schema.table("intakeqa", (table) => {
      req.body.obj.forEach((obj) => {
        table[obj.column_name](obj.column_type);
      });
    });
    res.send("Column Added!!");
  } catch (err) {
    console.error("❌ Error adding column:", err);
    res.status(500).send("An error occurred while adding the column.");
  }
});

app.put("/updateColumn", async (req, res) => {
  try {
    await knexClient("intakeqa").where({ id: req.body.id }).update({
      enable_ui: req.body.val,
    });
    res.send("Updated enable_ui!!");
  } catch (err) {
    console.error("❌ Error updating column:", err);
    res.status(500).send("An error occurred while updating the column.");
  }
});

app.delete("/deleteColumn", async (req, res) => {
  try {
    await knexClient.schema.table("intakeqa", (table) => {
      table.dropColumn(req.body.id);
    });
    res.send("Column Deleted!!");
  } catch (err) {
    console.error("❌ Error deleting column:", err);
    res.status(500).send("An error occurred while deleting the column.");
  }
});

const startServer = async () => {
  await initializeDatabase();
  app.listen(3000, () => {
    console.log("Server is running on port 3000");
  });
};

startServer();
