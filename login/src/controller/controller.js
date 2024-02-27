const UserModel = require("../model/user_model");

const cloudinary = require("cloudinary").v2;
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const transporter = require("../config/email_config");
const dotenv = require("dotenv");
dotenv.config();

// ! Configure Cloudinary
cloudinary.config({
  cloud_name: "divedztco",
  api_key: "871532557371698",
  api_secret: "iAjAJJzwO6BnxgD9OGk7KxryTuk",
});

class Controller {
  // ! register
  static register_user = async (req, res) => {
    try {
      const user = await UserModel.findOne({ email: req.body.email });
      if (user) {
        return res
          .status(200)
          .json({ success: false, msg: "This email already exists" });
      }

      if (req.body.password === req.body.confirmPassword) {
        const imageFile = req.files.image;
        const result = await cloudinary.uploader.upload(imageFile.tempFilePath);

        const users = new UserModel({
          name: req.body.name,
          email: req.body.email,
          password: req.body.password,
          confirmPassword: req.body.confirmPassword,
          image: result.url,
        });

        let user_data = await users.save();
        user_data = user_data.toObject();
        delete user_data.password;
        res.status(201).json({ success: true, data: user_data });
      } else {
        return res
          .status(200)
          .json({ success: false, msg: "This password dosen't match" });
      }
    } catch (error) {
      res.status(400).send({ success: false, error: error.message });
    }
  };

  // ! login
  static login_user = async (req, res) => {
    const user = await UserModel.findOne({ email: req.body.email });

    try {
      if (!user) {
        return res
          .status(404)
          .json({ success: false, msg: "This email is not registerd" });
      }
      const isMatch = await bcryptjs.compare(req.body.password, user.password);
      if (isMatch) {
        jwt.sign({ userID: user._id }, process.env.jwtKey, (error, token) => {
          let users = {
            _id: user._id,
            email: user.email,
            image: user.image,
            name: user.name,
            __v: user.__v,
          };
          console.log(error);

          res
            .status(202)
            .send({ success: true, data: { users, token: token } });
        });
      } else {
        res
          .status(404)
          .json({ success: false, error: "Un Authorized Request" });
      }
    } catch (error) {
      res.status(500).send("Error Occured");
    }
  };

  // ! change Password
  static change_password = async (req, res) => {
    const { password, confirmPassword } = req.body;

    if (password && confirmPassword) {
      if (password !== confirmPassword) {
        res.send({
          status: "failed",
          message: "New Password and Confirm New Password doesn't match",
        });
      } else {
        const newHashPassword = await bcryptjs.hash(password, 10);
        await UserModel.findByIdAndUpdate(
          { _id: req.users._id },
          { $set: { password: newHashPassword } }
        );
        res.send({
          status: "success",
          message: "Password changed succesfully",
        });
      }
    } else {
      res.send({ status: "failed", message: "All Fields are Required" });
    }
  };

  // ! profile
  static profile = (req, res) => {
    res.send(req.users);
  };

  // ! reset password
  static reset_password = async (req, res) => {
    const { email } = req.body;
    if (email) {
      const user = await UserModel.findOne({ email: email });
      if (user) {
        const secret = user._id + process.env.jwtKey;
        const token = jwt.sign({ userID: user._id }, secret, {
          expiresIn: "15m",
        });
        const link = `http://127.0.0.1:3000/api/reset/${user._id}/${token}`;
        console.log(link);
        // ! send email
        // const info = await transporter.sendMail({
        //   from: `"Syed Shahain 👻" <${process.env.EMAIL_FROM}>`, // sender address
        //   to: user.email, // list of receivers
        //   subject: "Shahzain - Password Reset Link ✔", // Subject line
        //   html: `<a href=${link}> Click Here</a> to Reset your Password`, // html body
        // });

        // console.log("Message sent: %s", info.messageId);
        res.send({
          status: "success",
          message: "Password Reset Email Sent... Please check your Email",
        });
      } else {
        res.send({ status: "failed", message: "Email does not exists" });
      }
    } else {
      res.send({ status: "failed", message: "Email field required" });
    }
  };
  // ! reset password
  static user_password_reset = async (req, res) => {
    const { password, confirmPassword } = req.body;
    const { id, token } = req.params;
    const user = await UserModel.findById(id);
    const newSecret = user._id + process.env.jwtKey;
    try {
      jwt.verify(token, newSecret);
      if (password && confirmPassword) {
        if (password !== confirmPassword) {
          res.send({
            status: "failed",
            message: "New Password and Confirm New Password doesn't match",
          });
        } else {
          const newHashPassword = await bcryptjs.hash(password, 10);
          await UserModel.findByIdAndUpdate(
            { _id: user._id },
            { $set: { password: newHashPassword } }
          );
          res.send({
            status: "success",
            message: "Password reset succesfully",
          });
        }
      } else {
        res.send({ status: "failed", message: "All feilds are required" });
      }
    } catch (error) {
      res.send({ status: "failed", message: "Invalid Token" });
    }
  };
}

module.exports = Controller;
