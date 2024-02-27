const jwt = require("jsonwebtoken");
const userModel = require("../model/user_model");

const userisAuth = async (req, res, next) => {
  let token;
  const { authorization } = req.headers;

  if (authorization && authorization.startsWith("Bearer")) {
    try {
      token = authorization.split(" ")[1];

      // ! verify token
      const { userID } = jwt.verify(token, process.env.jwtKey);
      req.users = await userModel.findById(userID).select("-password");
      next();
    } catch (error) {
      res.status(401).send({ status: "failed", message: "Unauthorized User" });
    }
  }
  if (!token) {
    res
      .status(401)
      .send({ status: "failed", message: "Unauthorized User, No Token" });
  }
};

module.exports = userisAuth;
