const express = require("express");

// Load the built express-ws and check what express it's using
const distCode = require("@mintplex-labs/express-ws/dist/index.js");

// Manually load express the same way the built code does
const __toESM = (mod, isNodeMode, target) => {
  target = mod != null ? Object.create(Object.getPrototypeOf(mod)) : {};
  const copyProps = (to, from, except, desc) => {
    if (from && typeof from === "object" || typeof from === "function") {
      for (let key of Object.getOwnPropertyNames(from))
        if (!Object.prototype.hasOwnProperty.call(to, key) && key !== except)
          Object.defineProperty(to, key, { get: () => from[key], enumerable: !(desc = Object.getOwnPropertyDescriptor(from, key)) || desc.enumerable });
    }
    return to;
  };
  return copyProps(
    isNodeMode || !mod || !mod.__esModule ? Object.defineProperty(target, "default", { value: mod, enumerable: true }) : target,
    mod
  );
};

const import_express = __toESM(require("express"));

console.log("Server express:", express);
console.log("Server express.Router:", express.Router);
console.log("\nBuilt code import_express.default:", import_express.default);
console.log("Built code import_express.default.Router:", import_express.default.Router);

console.log("\nAre they the same?");
console.log("express === import_express.default:", express === import_express.default);
console.log("express.Router === import_express.default.Router:", express.Router === import_express.default.Router);
