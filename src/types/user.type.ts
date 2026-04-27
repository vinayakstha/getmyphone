import z from "zod";

export const UserSchema = z.object({
  email: z.email(),
  fullName: z.email(),
  phoneNumber: z.string().min(10),
  password: z.string().min(6),
  profilePicture: z.string(),
  role: z.enum(["user", "admin"]).default("user"),
});

export type UserType = z.infer<typeof UserSchema>;
