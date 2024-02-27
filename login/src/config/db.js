const mongoose = require("mongoose");

mongoose
  .connect("mongodb://localhost:27017/users")
  .then((_) => {
    console.log("done");
  })
  .catch((error) => {
    console.log("error");
  });

module.exports = mongoose;
