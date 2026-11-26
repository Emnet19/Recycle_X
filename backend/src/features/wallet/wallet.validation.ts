import { z } from 'zod';

export const redeemRewardSchema = z.object({
  rewardId: z.string().min(1, 'Reward ID is required.'),
  coinsCost: z.number().int().positive('Coins cost must be a positive integer.'),
  itemTitle: z.string().min(2, 'Item title is required.'),
});

export const transferCoinsSchema = z.object({
  recipientPhoneNumber: z.string().min(9, 'Recipient phone number is required.'),
  amount: z.number().int().positive('Amount must be positive.'),
  note: z.string().optional(),
});

