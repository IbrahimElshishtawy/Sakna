const jwt = require('jsonwebtoken');

module.exports = function(req, res, next) {
  const token = req.header('x-auth-token');

  if (!token) {
    return res.status(401).json({ msg: 'No token, authorization denied' });
  }

  // Ensure JWT_SECRET is set
  const secret = process.env.JWT_SECRET;
  if (!secret) {
      console.error('CRITICAL ERROR: JWT_SECRET environment variable is not defined!');
      return res.status(500).json({ msg: 'Internal server error' });
  }

  try {
    const decoded = jwt.verify(token, secret);
    req.user = decoded.user;
    next();
  } catch (err) {
    res.status(401).json({ msg: 'Token is not valid' });
  }
};
