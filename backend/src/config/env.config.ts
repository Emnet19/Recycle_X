import dotenv from 'dotenv';
import { z } from 'zod';

// Load .env file
dotenv.config();

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
  PORT: z.coerce.number().default(5000),
  API_PREFIX: z.string().default('/api/v1'),

  MONGO_URI: z.string().default('mongodb://localhost:27017/recyclex_db'),

  JWT_ACCESS_SECRET: z.string().min(16).default('recyclex_development_jwt_access_secret_key_minimum_32_chars'),
  JWT_REFRESH_SECRET: z.string().min(16).default('recyclex_development_jwt_refresh_secret_key_minimum_32_chars'),
  JWT_ACCESS_EXPIRES_IN: z.string().default('15m'),
  JWT_REFRESH_EXPIRES_IN: z.string().default('7d'),

  ARGON_TIME_COST: z.coerce.number().default(3),
  ARGON_MEMORY_COST: z.coerce.number().default(65536),
  ARGON_PARALLELISM: z.coerce.number().default(4),

  CORS_ORIGIN: z.string().default('http://localhost:3000,http://localhost:8080,http://127.0.0.1:3000'),
});

const parsed = envSchema.safeParse(process.env);

if (!parsed.success) {
  console.error('❌ Invalid environment configuration:', JSON.stringify(parsed.error.format(), null, 2));
  process.exit(1);
}

export const env = parsed.data;

