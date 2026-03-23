const mongoose = require('mongoose');

const taskSchema = new mongoose.Schema({
  clientId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  helperId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  serviceType: { type: String, required: true },
  category: { type: String, required: true },
  description: String,
  isUrgent: { type: Boolean, default: false },
  scheduledAt: { type: Date, default: Date.now },
  location: {
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: { type: [Number], required: true } // [lng, lat]
  },
  address: { type: String, required: true },
  price: { type: Number, required: true },
  hours: { type: Number, default: 1 },
  status: {
    type: String,
    enum: ['pending', 'matched', 'in_progress', 'completed', 'disputed'],
    default: 'pending'
  },
  progressPhotos: [String],
  ratingBreakdown: {
    speed: { type: Number, min: 1, max: 5 },
    quality: { type: Number, min: 1, max: 5 },
    communication: { type: Number, min: 1, max: 5 }
  },
  createdAt: { type: Date, default: Date.now }
});

taskSchema.index({ location: '2dsphere' });

module.exports = mongoose.model('Task', taskSchema);
