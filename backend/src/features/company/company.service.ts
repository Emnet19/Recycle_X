import { CompanyMaterialModel, ICompanyMaterial } from './company-material.model';
import { UserModel } from '../users/user.model';
import { AppError } from '../../shared/errors/app-error';
import { HttpStatus } from '../../constants/http-status.constant';
import { ErrorCode } from '../../constants/error-codes.constant';

export class CompanyService {
  async getProfile(companyId: string) {
    const company = await UserModel.findById(companyId).select('-passwordHash');
    if (!company) {
      throw new AppError('Company not found.', HttpStatus.NOT_FOUND, ErrorCode.NOT_FOUND);
    }
    return company;
  }

  async updateProfile(companyId: string, dto: Record<string, unknown>) {
    const company = await UserModel.findByIdAndUpdate(
      companyId,
      { $set: dto },
      { new: true }
    ).select('-passwordHash');
    if (!company) {
      throw new AppError('Company not found.', HttpStatus.NOT_FOUND, ErrorCode.NOT_FOUND);
    }
    return company;
  }

  async listMaterials(companyId: string): Promise<ICompanyMaterial[]> {
    return CompanyMaterialModel.find({ companyId, isActive: true });
  }

  async createMaterial(companyId: string, dto: Record<string, unknown>): Promise<ICompanyMaterial> {
    return CompanyMaterialModel.create({ ...dto, companyId });
  }

  async updateMaterial(
    companyId: string,
    materialId: string,
    dto: Record<string, unknown>
  ): Promise<ICompanyMaterial> {
    const material = await CompanyMaterialModel.findOneAndUpdate(
      { _id: materialId, companyId },
      { $set: dto },
      { new: true }
    );
    if (!material) {
      throw new AppError('Material not found.', HttpStatus.NOT_FOUND, ErrorCode.NOT_FOUND);
    }
    return material;
  }

  async deleteMaterial(companyId: string, materialId: string): Promise<void> {
    const result = await CompanyMaterialModel.findOneAndUpdate(
      { _id: materialId, companyId },
      { $set: { isActive: false } }
    );
    if (!result) {
      throw new AppError('Material not found.', HttpStatus.NOT_FOUND, ErrorCode.NOT_FOUND);
    }
  }
}

export const companyService = new CompanyService();

