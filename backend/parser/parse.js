import xlsx from "node-xlsx";
import XLSX from "xlsx";
import fs from "fs";
import { format, join } from "path";

function parseAllFiles(folderPath) {
  const files = fs.readdirSync(folderPath);
  files.forEach((file) => {
    const arr = parseFile(join(folderPath, file));
    fs.writeFileSync(join(folderPath, file.replace(".xlsx", ".json")), JSON.stringify(arr));
  });
}

function parseFile(filePath) {
  const workbook = XLSX.readFile(filePath);
  const sheet = workbook.SheetNames[0];
  var arr = XLSX.utils.sheet_to_json(workbook.Sheets[sheet], { defval: "" });

  // split list options from string to list
  arr = arr.map((obj) => {
    const newObj = {};
    for (let key in obj) {
      const formattedKey = key.replace(/\s+/g, "_").toLowerCase();
      newObj[formattedKey] = obj[key];
      if (
        formattedKey === "column_type" &&
        newObj["column_type"].toLowerCase().includes("varchar")
      ) {
        newObj["max"] != ""
          ? (newObj["column_type"] =
              newObj["column_type"].split("(")[0] + "(" + 255 + ")")
          : (newObj["column_type"] =
              newObj["column_type"].split("(")[0] + "(" + newObj["max"] + ")");
      }
    }

    return newObj;
  });

  // create ui type object for each field
  arr = arr.map((obj) => {
    if (obj.enable_ui === 1) {
      const newObj = { ...obj };
      if (newObj["field_type_m"] === "Input Box" && newObj["required"] != "") {
        newObj["ui_type"] = {
          type: "textfield",
          label: newObj["label_name"],
          required: newObj["required"],
        };
      } else if (
        newObj["field_type_m"] === "Button" &&
        newObj["required"] != ""
      ) {
        newObj["ui_type"] = {
          type: "button",
          label: newObj["label_name"],
          buttons: newObj["list_options"],
          required: newObj["required"],
        };
      } else if (
        newObj["field_type_m"] === "Dropdown" &&
        newObj["required"] != ""
      ) {
        newObj["ui_type"] = {
          type: "dropdown",
          label: newObj["label_name"],
          list_options: newObj["list_options"],
          required: newObj["required"],
        };
      }
      return newObj;
    }
  });

  return arr;
}

export default parseFile;
