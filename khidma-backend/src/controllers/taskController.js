const Task = require('../models/Task');
const User = require('../models/User');

// Create Task with pricing and GeoJSON location
exports.createTask = async (req, res) => {
  try {
    const { isUrgent, hourlyPrice, hours, lng, lat, address, serviceType, category, description } = req.body;

    if (!lng || !lat) return res.status(400).json({ error: 'Coordinates are required' });

    let finalPrice = hourlyPrice * hours;
    if (isUrgent) finalPrice *= 1.5;

    const task = new Task({
      clientId: req.user.id,
      serviceType,
      category,
      description,
      isUrgent,
      address,
      hours,
      price: finalPrice,
      location: {
        type: 'Point',
        coordinates: [parseFloat(lng), parseFloat(lat)]
      },
      status: 'pending'
    });
    await task.save();
    res.status(201).json(task);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Reorder Task (Cloning)
exports.reorderTask = async (req, res) => {
    try {
      const originalTask = await Task.findById(req.params.id);
      if (!originalTask) return res.status(404).json({ error: 'Original task not found' });

      // Ownership check
      if (originalTask.clientId.toString() !== req.user.id) {
          return res.status(403).json({ error: 'Unauthorized: This is not your task' });
      }

      const newTask = new Task({
          clientId: req.user.id,
          serviceType: originalTask.serviceType,
          category: originalTask.category,
          description: originalTask.description,
          location: originalTask.location,
          address: originalTask.address,
          price: originalTask.price,
          hours: originalTask.hours,
          status: 'pending',
          scheduledAt: new Date()
      });

      await newTask.save();
      res.status(201).json(newTask);
    } catch (err) {
      res.status(400).json({ error: err.message });
    }
};

// Advanced Rating and Badge Logic with Ownership Protection
exports.submitRating = async (req, res) => {
    try {
      const { id } = req.params;
      const { speed, quality, communication } = req.body;

      const task = await Task.findById(id);
      if (!task || task.status !== 'completed') {
          return res.status(400).json({ error: 'Only completed tasks can be rated' });
      }

      // Ownership check: Only the client who ordered the task can rate it
      if (task.clientId.toString() !== req.user.id) {
          return res.status(403).json({ error: 'Unauthorized: Only the client can rate this task' });
      }

      task.ratingBreakdown = { speed, quality, communication };
      await task.save();

      // Update Helper average rating
      const avg = (speed + quality + communication) / 3;
      const helper = await User.findById(task.helperId);
      if (helper) {
          helper.rating = (helper.rating + avg) / 2;
          if (helper.rating >= 4.8 && !helper.badges.includes('Top Rated')) {
              helper.badges.push('Top Rated');
          }
          await helper.save();
      }

      res.json({ task, helperRating: helper ? helper.rating : null });
    } catch (err) {
      res.status(400).json({ error: err.message });
    }
};

// Geoproximity Search Implementation
exports.getTasks = async (req, res) => {
  try {
    const { lng, lat, distance = 5000 } = req.query;

    let query = {};
    if (lng && lat) {
      query.location = {
        $near: {
          $geometry: { type: "Point", coordinates: [parseFloat(lng), parseFloat(lat)] },
          $maxDistance: parseInt(distance)
        }
      };
    }

    const tasks = await Task.find(query).populate('clientId', 'name rating avatarUrl');
    res.json(tasks);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Protected Status Update with Ownership Protection
exports.updateStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const task = await Task.findById(req.params.id);

    if (!task) return res.status(404).json({ error: 'Task not found' });

    // Ownership check: Only the client or the assigned helper can update status
    const isClient = task.clientId.toString() === req.user.id;
    const isHelper = task.helperId && task.helperId.toString() === req.user.id;

    if (!isClient && !isHelper) {
        return res.status(403).json({ error: 'Unauthorized: You are not involved in this task' });
    }

    // Simple state machine validation
    const allowedTransitions = {
        'pending': ['matched', 'disputed'],
        'matched': ['in_progress', 'disputed'],
        'in_progress': ['completed', 'disputed'],
        'completed': [],
        'disputed': ['pending', 'completed']
    };

    if (!allowedTransitions[task.status].includes(status)) {
        return res.status(400).json({ error: `Invalid status transition from ${task.status} to ${status}` });
    }

    task.status = status;
    await task.save();
    res.json(task);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};
