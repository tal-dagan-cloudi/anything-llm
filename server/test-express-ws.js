const express = require("express");
const expressWs = require("@mintplex-labs/express-ws").default;

const app = express();
const apiRouter = express.Router();

console.log("Before initialization:");
console.log("app.ws type:", typeof app.ws);
console.log("apiRouter.ws type:", typeof apiRouter.ws);
console.log("express.Router.ws type:", typeof express.Router.ws);

// Initialize express-ws
const result = expressWs(app);

console.log("\nAfter initialization:");
console.log("app.ws type:", typeof app.ws);
console.log("apiRouter.ws type:", typeof apiRouter.ws);
console.log("express.Router.ws type:", typeof express.Router.ws);
console.log("Result:", result);

// Create a new router after initialization
const newRouter = express.Router();
console.log("\nNew router created after init:");
console.log("newRouter.ws type:", typeof newRouter.ws);
