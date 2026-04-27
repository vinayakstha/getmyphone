import z from "zod";
import { UserSchema } from "../types/user.type";

export const CreateUserDTO = UserSchema.pick({
  fullName: true,
  email: true,
  phoneNumber: true,
  password: true,
})
  .extend({
    confirmPassword: z.string().min(6),
    profilePicture: z.string().optional(),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: "passwords do not match",
    path: ["confirmPassword"],
  });

export type CreateUserDTO = z.infer<typeof CreateUserDTO>;

export const LoginUserDTO = z.object({
  email: z.email(),
  password: z.string().min(6),
});

export type LoginUserDTO = z.infer<typeof LoginUserDTO>;

export const UpdateUserDTO = z.object({
  fullName: z.string().optional(),
  email: z.string().optional(),
  phoneNumber: z.string().optional(),
  profilePicture: z.string().optional(),
});

// export const UpdateUserDTO = UserSchema.partial();
export type UpdateUserDTO = z.infer<typeof UpdateUserDTO>;
