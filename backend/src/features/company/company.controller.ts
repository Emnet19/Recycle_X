import { Request, Response, NextFunction } from 'express';
import { companyService } from './company.service';
import { ApiResponse } from '../../shared/utils/api-response';

export class CompanyController {
  async getProfile(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const profile = await companyService.getProfile(req.user!.id);
      ApiResponse.success(res, profile);
    } catch (error) {
      next(error);
    }
  }

  async updateProfile(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const updated = await companyService.updateProfile(req.user!.id, req.body);
      ApiResponse.success(res, updated, 'Company profile updated.');
    } catch (error) {
      next(error);
    }
  }

  async listMaterials(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const materials = await companyService.listMaterials(req.user!.id);
      ApiResponse.success(res, materials);
    } catch (error) {
      next(error);
    }
  }

  async createMaterial(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const material = await companyService.createMaterial(req.user!.id, req.body);
      ApiResponse.created(res, material, 'Material added successfully.');
    } catch (error) {
      next(error);
    }
  }

  async updateMaterial(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { materialId } = req.params;
      const material = await companyService.updateMaterial(req.user!.id, materialId, req.body);
      ApiResponse.success(res, material, 'Material updated.');
    } catch (error) {
      next(error);
    }
  }

  async deleteMaterial(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { materialId } = req.params;
      await companyService.deleteMaterial(req.user!.id, materialId);
      ApiResponse.noContent(res);
    } catch (error) {
      next(error);
    }
  }
}

export const companyController = new CompanyController();

