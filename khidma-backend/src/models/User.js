const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, unique: true, required: true },
  password: { type: String, required: true },
  role: { type: String, enum: ['client', 'helper'], default: 'client' },
  city: String,
  location: {
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: { type: [Number], required: true } // [lng, lat]
  },
  rating: { type: Number, default: 5.0 },
  avatarUrl: String,
  subscriptionType: { type: String, enum: ['basic', 'pro', 'premium'], default: 'basic' },
  badges: [String],
  favorites: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
  walletBalance: { type: Number, default: 0.0 },
  status: { type: String, enum: ['online', 'offline'], default: 'offline' },
  availability: { type: String, enum: ['available', 'busy'], default: 'available' },
  createdAt: { type: Date, default: Date.now }
});

userSchema.index({ location: '2dsphere' });

module.exports = mongoose.model('User', userSchema);
