import { z } from 'zod';
import { PickupType, PickupStatus, WasteCategory } from './collection.model';

export const createPickupSchema = z.object({
  type: z.nativeEnum(PickupType).default(PickupType.SCHEDULED),
  categories: z.array(z.nativeEnum(WasteCategory)).min(1, 'Select at least one waste category.'),
  estimatedWeightKg: z.number().positive().optional(),
  scheduledDate: z.string().datetime().or(z.string().min(8)),
  address: z.object({
    street: z.string().min(2, 'Street is required.'),
    subcity: z.string().min(2, 'Subcity is required.'),
    kebele: z.string().optional(),
    coordinates: z
      .object({
        lat: z.number(),
        lng: z.number(),
      })
      .optional(),
  }),
  notes: z.string().optional(),
});

export const updatePickupStatusSchema = z.object({
  status: z.nativeEnum(PickupStatus),
  actualWeightKg: z.number().positive().optional(),
});

