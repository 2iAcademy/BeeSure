import { IsNotEmpty, IsString, Length } from 'class-validator';

export class VerifyPhoneDto {
  @IsString()
  @IsNotEmpty()
  phone: string;

  @IsString()
  @IsNotEmpty()
  @Length(6, 6, {
    message: 'Le code de vérification doit contenir exactement 6 chiffres',
  })
  verificationCode: string;
}
