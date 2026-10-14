const mongoose = require('mongoose');
const env = require('./env');

/**
 * Connect to MongoDB database
 * Provides resilient error handling so the API server can still start
 * even in offline test environments.
 */
const connectDB = async () => {
  try {
    const conn = await mongoose.connect(env.MONGODB_URI, {
      serverSelectionTimeoutMS: 3000,
    });
    console.log(`[MongoDB] Connected successfully: ${conn.connection.host}`);
  } catch (error) {
    console.warn(`[MongoDB Warning] Could not connect to MongoDB at ${env.MONGODB_URI}`);
    console.warn(`[MongoDB Warning] Details: ${error.message}`);
    console.warn(`[MongoDB Note] Ensure MongoDB is running locally (mongod) or configure MONGODB_URI in .env`);
  }
};

module.exports = connectDB;
