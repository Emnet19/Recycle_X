import { Request, Response, NextFunction } from 'express';
import { collectionService } from './collection.service';
import { ApiResponse } from '../../shared/utils/api-response';
import { PickupStatus } from './collection.model';

export class CollectionController {
  async createPickup(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const pickup = await collectionService.createPickup(req.user!.id, req.body);
      ApiResponse.created(res, pickup, 'Pickup request submitted successfully.');
    } catch (error) {
      next(error);
    }
  }

  async listOwnPickups(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const pickups = await collectionService.listCustomerPickups(req.user!.id);
      ApiResponse.success(res, pickups);
    } catch (error) {
      next(error);
    }
  }

  async listPending(_req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const pickups = await collectionService.listPendingPickups();
      ApiResponse.success(res, pickups);
    } catch (error) {
      next(error);
    }
  }

  async listAssigned(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const pickups = await collectionService.listAssignedPickups(req.user!.id);
      ApiResponse.success(res, pickups);
    } catch (error) {
      next(error);
    }
  }

  async acceptPickup(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const pickup = await collectionService.acceptPickup(req.params.id, req.user!.id);
      ApiResponse.success(res, pickup, 'Pickup accepted successfully.');
    } catch (error) {
      next(error);
    }
  }

  async updateStatus(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { status, actualWeightKg } = req.body as { status: PickupStatus; actualWeightKg?: number };
      const pickup = await collectionService.updateStatus(
        req.params.id,
        req.user!.id,
        status,
        actualWeightKg
      );
      ApiResponse.success(res, pickup, 'Pickup status updated.');
    } catch (error) {
      next(error);
    }
  }
}

export const collectionController = new CollectionController();
