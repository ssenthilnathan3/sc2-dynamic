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


// Converts excel file to json based on the file name!
app.get("/parseExcelToJSON/:filename", (req, res) => {
  const { filename } = req.params;
  var arr = parseFile(`parser/${filename}.xlsx`);
  fs.writeFileSync(`parser/${filename}.json`, JSON.stringify(arr));
  res.status(200).send({
    "status-code": 200,
    message: "data parsed successfully",
    data: arr,
  });
});

app.get("/get/:tablename", async (req, res) => {
  const { tablename } = req.params;
  try {
    const data = await knexClient(tablename).select("*");
    res.send(data);
  } catch (err) {
    console.error("❌ Error fetching data:", err);
    res.status(500).send("An error occurred while fetching data.");
  }
});

app.get("/createTableFromJson/:name", async (req, res) => {
  const { name } = req.params;
  try {
    fs.readFile(`parser/${name}.json`, "utf8", async (error, data) => {
      if (error) {
        console.error("❌ Error reading JSON file:", error);
        res.status(500).send("An error occurred while reading the JSON file.");
        return;
      }

      const arr_json = JSON.parse(data);

      try {
        await createNewTable(name, arr_json);
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

app.get("/insertIfNotExists/:tablename", async (req, res) => {
  const { tablename } = req.params;
  try {
    fs.readFile(`parser/${tablename}.json`, "utf8", async (error, data) => {
      if (error) {
        console.error("❌ Error reading JSON file:", error);
        res.status(500).send("An error occurred while reading the JSON file.");
        return;
      }

      const arr_json = JSON.parse(data);

      try {
        const exist = await checkIfDataExistsOnTable(tablename);
        if (exist) {
          res.status(200).send("Data already exists.");
          return;
        } else {
          await insertAllData(tablename, arr_json);
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

app.post("/addColumn/:tablename", async (req, res) => {
  const { tablename } = req.params;
  try {
    await knexClient.schema.table(tablename, (table) => {
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

app.put("/updateColumn/:tablename", async (req, res) => {
  const { tablename } = req.params;
  try {
    await knexClient(tablename).where({ id: req.body.id }).update({
      enable_ui: req.body.val,
    });
    res.send("Updated enable_ui!!");
  } catch (err) {
    console.error("❌ Error updating column:", err);
    res.status(500).send("An error occurred while updating the column.");
  }
});

app.delete("/deleteColumn/:tablename", async (req, res) => {
  const { tablename } = req.params;
  try {
    await knexClient.schema.table(tablename, (table) => {
      table.dropColumn(req.body.id);
    });
    res.send("Column Deleted!!");
  } catch (err) {
    console.error("❌ Error deleting column:", err);
    res.status(500).send("An error occurred while deleting the column.");
  }
});

app.post("/postFormData/:name", async (req, res) => {
  const { name } = req.params;
  const slug = name.toLowerCase().replace(/\s+/g, "-");
  console.log(slug);
  console.log(req.body);
  // TODO: create schema from req.body keys
  
  if (slug == "drymatterresult") {
    try {
      await createNewTable(slug, req.body);
      await insertAllData(slug, req.body);
      res.status(200).send("Data inserted successfully.");
    } catch (e) {
      console.log(e);
    }
  }
});

const startServer = async () => {
  await initializeDatabase();
  app.listen(3000, () => {
    console.log("Server is running on port 3000");
  });
};

startServer();
