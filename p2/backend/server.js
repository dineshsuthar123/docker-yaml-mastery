const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const redis = require('redis');

const app = express();
const PORT = process.env.PORT || 5000;

// Database connection
const pool = new Pool({
    connectionString: process.env.DB_URL,
});

// Redis connection
const redisClient = redis.createClient({
    url: 'redis://redis:6379'
});

// Middleware
app.use(cors());
app.use(express.json());

// Connect to Redis
redisClient.connect().catch(console.error);

// Routes
app.get('/', (req, res) => {
    res.json({ message: 'Backend API is running!' });
});

app.get('/users', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM users');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Database error' });
    }
});

app.get('/posts', async (req, res) => {
    try {
        // Try to get from cache first
        const cached = await redisClient.get('posts');
        if (cached) {
            return res.json(JSON.parse(cached));
        }

        const result = await pool.query(`
      SELECT p.*, u.username 
      FROM posts p 
      JOIN users u ON p.user_id = u.id 
      ORDER BY p.created_at DESC
    `);

        // Cache for 5 minutes
        await redisClient.setEx('posts', 300, JSON.stringify(result.rows));
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Database error' });
    }
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
