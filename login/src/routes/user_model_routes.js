const express = require("express");
const fileUpload = require("express-fileupload");
const user_controller = require("../controller/controller");
const app = express();

const authMiddle = require("../middleware/auth_middleware");

app.use(express.json());

app.use("/change_password", authMiddle);
app.use("/profile", authMiddle);

app.use(
  fileUpload({
    useTempFiles: true,
  })
);

// * public routes

// ! register api
app.post("/registers", user_controller.register_user);

// ! login api
app.post("/login", user_controller.login_user);

// ! reset api
app.post("/reset", user_controller.reset_password);
app.post("/reset-password/:id/:token", user_controller.user_password_reset);

// * Protected routes

// ! change Password
app.post("/change_password", user_controller.change_password);

// ! profile
app.get("/profile", user_controller.profile);

module.exports = app;
