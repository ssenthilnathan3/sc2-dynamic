import knex from "knex";
import arr from "./parse.js";
const dbName = "intakeqa";
// create knex client
const conn = {
  host: "127.0.0.1",
  user: "root",
  password: "",
  charset: "utf8",
};

let knexClient = knex({ client: "mysql", connection: conn });

const initializeDatabase = async () => {
  try {
    console.log("✅ Connection Created!!");
    await knexClient.raw(`CREATE DATABASE IF NOT EXISTS ${dbName}`);
    console.log("✅ Database Created!!");

    // Update connection object to include database
    conn.database = dbName;
    knexClient = knex({ client: "mysql", connection: conn });
    console.log("✅ Database Selected!!");
  } catch (err) {
    console.error("❌ Error creating or selecting database:", err);
  }
};

const checkIfDataExistsOnTable = async (table_name) => {
  const data = await knexClient
    .from(table_name)
    .select(knexClient.raw("1 as has_data"))
    .limit(1);
  return data.length > 0;
};

const checkIfRowExists = async (table_name, id) => {
  const data = await knexClient(table_name).where({ id: id });
  return data.length > 0;
};

const createNewTable = async (table_name, schema_arr) => {
  await knexClient.schema.createTableIfNotExists(table_name, (table) => {
    Object.keys(schema_arr[0]).forEach((key) => {
      table.string(key, 255);
    });
  });
  console.log("✅ Table Created!!");
};

const insertAllData = async (table_name, data) => {
  await knexClient(table_name).insert(data);
  console.log("✅ Data Inserted!!");
};


const updateEnableUi = async (id, val) => {
  await knexClient("intakeqa").where({ id: id }).update({
    enable_ui: val,
  });
  console.log("✅ Updated enable_ui!!");
};

const deleteColumn = async (id) => {
  await knexClient.schema.table("intakeqa", (table) => {
    table.dropColumn(id);
  });
  console.log("✅ Column Deleted!!");
};

export {
  initializeDatabase,
  createNewTable,
  updateEnableUi,
  deleteColumn,
  insertAllData,
  checkIfDataExistsOnTable,
  checkIfRowExists
};
