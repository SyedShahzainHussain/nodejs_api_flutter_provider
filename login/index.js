const express = require("express");
const dotenv = require('dotenv')
dotenv.config();
const port = 8000 ;
require("./src/config/db");
const app = express();
const user_route = require("./src/routes/user_model_routes");

app.use("/api",user_route);


app.listen(port, () => {
  console.log("Your server is running on this port " + port);
});
