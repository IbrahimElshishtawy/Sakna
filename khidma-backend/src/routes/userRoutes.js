const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const auth = require('../middleware/auth');

router.get('/:id', auth, userController.getProfile);
router.post('/:id/wallet', auth, userController.updateWallet);
router.put('/:id/subscription', auth, userController.updateSubscription);
router.post('/favorites/:helperId', auth, userController.toggleFavorite);

module.exports = router;
