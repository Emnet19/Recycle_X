import { Schema, model, Document, Types } from 'mongoose';

export enum MaterialCategory {
  PLASTIC = 'plastic',
  PAPER = 'paper',
  METAL = 'metal',
  ORGANIC = 'organic',
  ELECTRONIC = 'electronic',
  GLASS = 'glass',
  TEXTILE = 'textile',
}

export interface ICompanyMaterial extends Document {
  companyId: Types.ObjectId;
  category: MaterialCategory;
  name: string;
  pricePerKg: number;
  minimumWeightKg: number;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const CompanyMaterialSchema = new Schema<ICompanyMaterial>(
  {
    companyId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    category: {
      type: String,
      enum: Object.values(MaterialCategory),
      required: true,
    },
    name: {
      type: String,
      required: true,
      trim: true,
    },
    pricePerKg: {
      type: Number,
      required: true,
      min: 0,
    },
    minimumWeightKg: {
      type: Number,
      default: 1,
      min: 0,
    },
    isActive: {
      type: Boolean,
      default: true,
    },
  },
  { timestamps: true, versionKey: false }
);

export const CompanyMaterialModel = model<ICompanyMaterial>('CompanyMaterial', CompanyMaterialSchema);

