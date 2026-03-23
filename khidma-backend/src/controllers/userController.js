const User = require('../models/User');

// Get User Profile
exports.getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.params.id).select('-password');
    if (!user) return res.status(404).json({ error: 'User not found' });
    res.json(user);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Atomic Wallet Update with IDOR Protection
exports.updateWallet = async (req, res) => {
  try {
    const { amount } = req.body;

    // IDOR Protection: Ensure user can only update their own wallet
    if (req.params.id !== req.user.id) {
        return res.status(403).json({ error: 'Unauthorized: You can only update your own wallet' });
    }

    const query = { _id: req.user.id };
    if (amount < 0) {
      query.walletBalance = { $gte: Math.abs(amount) };
    }

    const updatedUser = await User.findOneAndUpdate(
      query,
      { $inc: { walletBalance: amount } },
      { new: true }
    );

    if (!updatedUser) {
      return res.status(400).json({ error: 'Insufficient funds or user not found' });
    }

    res.json({ balance: updatedUser.walletBalance });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Toggle Favorites
exports.toggleFavorite = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    const targetId = req.params.helperId;

    if (user.favorites.includes(targetId)) {
        user.favorites.pull(targetId);
    } else {
        user.favorites.push(targetId);
    }

    await user.save();
    res.json({ favorites: user.favorites });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Handle Subscription Tiers with IDOR Protection
exports.updateSubscription = async (req, res) => {
  try {
    const { tier } = req.body;

    // IDOR Protection: Ensure user can only update their own subscription
    if (req.params.id !== req.user.id) {
        return res.status(403).json({ error: 'Unauthorized: You can only update your own subscription' });
    }

    const update = { $set: { subscriptionType: tier } };
    if (tier === 'pro') {
      update.$addToSet = { badges: 'Pro Provider' };
    }

    const user = await User.findByIdAndUpdate(req.user.id, update, { new: true });
    res.json(user);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};
