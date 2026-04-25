import express, { Application, Request, Response } from "express";
import bodyParser from "body-parser";
import dotenv from "dotenv";
import cors from "cors";
import path from "path";

dotenv.config();

const app: Application = express();

let corsOption = {
  origin: ["http://localhost:3000", "http://localhost:3003"],
};

app.use(cors(corsOption));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get("/", (req: Request, res: Response) => {
  return res
    .status(200)
    .json({ success: "true", message: "welcome to the api" });
});

export default app;
