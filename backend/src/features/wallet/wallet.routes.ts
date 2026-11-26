import { Router } from 'express';
import { walletController } from './wallet.controller';
import { authenticate } from '../../middleware/authenticate.middleware';
import { validate } from '../../middleware/validate.middleware';
import { redeemRewardSchema } from './wallet.validation';

const router = Router();

router.use(authenticate);

router.get('/balance', walletController.getBalance);
router.get('/transactions', walletController.listTransactions);
router.post('/redeem', validate({ body: redeemRewardSchema }), walletController.redeemReward);

export const walletRoutes = router;

