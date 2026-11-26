import argon2 from 'argon2';
import { env } from '../config/env.config';

export class PasswordSecurity {
  static async hash(password: string): Promise<string> {
    return argon2.hash(password, {
      type: argon2.argon2id,
      timeCost: env.ARGON_TIME_COST,
      memoryCost: env.ARGON_MEMORY_COST,
      parallelism: env.ARGON_PARALLELISM,
    });
  }

  static async verify(hash: string, plainText: string): Promise<boolean> {
    try {
      return await argon2.verify(hash, plainText);
    } catch {
      return false;
    }
  }
}

