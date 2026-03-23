const express = require('express');
const router = express.Router();
const taskController = require('../controllers/taskController');
const auth = require('../middleware/auth');

router.post('/create', auth, taskController.createTask);
router.get('/', taskController.getTasks);
router.put('/:id/status', auth, taskController.updateStatus);
router.post('/:id/rate', auth, taskController.submitRating);
router.post('/:id/reorder', auth, taskController.reorderTask);

module.exports = router;
