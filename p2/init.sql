-- Initialize database with sample data
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    user_id INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Insert sample data
INSERT INTO users (username, email)
VALUES ('john_doe', 'john@example.com'),
    ('jane_smith', 'jane@example.com');
INSERT INTO posts (title, content, user_id)
VALUES ('First Post', 'This is my first post!', 1),
    ('Second Post', 'Another interesting post', 2);