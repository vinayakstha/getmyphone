import express, { Application, Request, Response } from "express";
import bodyParser from "body-parser";
import dotenv from "dotenv";
import cors from "cors";
import path from "path";

import authRoutes from "./routes/auth.route";
import userRoutes from "./routes/user.route";

dotenv.config();

const app: Application = express();

let corsOption = {
  origin: ["http://localhost:3000", "http://localhost:3003"],
};

app.use(cors(corsOption));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// app.use("/uploads", express.static(path.join(__dirname, "../../uploads")));
const uploadsPath = path.resolve(__dirname, "../uploads"); // adjust based on where uploads is
app.use("/uploads", express.static(uploadsPath));

//user routes
app.use("/api/auth", authRoutes);
app.use("/api/user", userRoutes);

app.get("/", (req: Request, res: Response) => {
  return res
    .status(200)
    .json({ success: "true", message: "welcome to the api" });
});

export default app;
