-- Create database
CREATE DATABASE IF NOT EXISTS social_media_db;
USE social_media_db;

-- Create Users table
CREATE TABLE IF NOT EXISTS Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Posts table
CREATE TABLE IF NOT EXISTS Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create Comments table
CREATE TABLE IF NOT EXISTS Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    user_id INT,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create Likes table
CREATE TABLE IF NOT EXISTS Likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create Shares table
CREATE TABLE IF NOT EXISTS Shares (
    share_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Insert sample data into Users
INSERT INTO Users (username, email) VALUES ('alice', 'alice@example.com');
INSERT INTO Users (username, email) VALUES ('bob', 'bob@example.com');
INSERT INTO Users (username, email) VALUES ('charlie', 'charlie@example.com');

-- Insert sample data into Posts
INSERT INTO Posts (user_id, content) VALUES (1, 'Alice\'s first post');
INSERT INTO Posts (user_id, content) VALUES (2, 'Bob\'s first post');
INSERT INTO Posts (user_id, content) VALUES (3, 'Charlie\'s first post');

-- Insert sample data into Comments
INSERT INTO Comments (post_id, user_id, comment) VALUES (1, 2, 'Nice post, Alice!');
INSERT INTO Comments (post_id, user_id, comment) VALUES (2, 1, 'Thanks, Bob!');

-- Insert sample data into Likes
INSERT INTO Likes (post_id, user_id) VALUES (1, 2);
INSERT INTO Likes (post_id, user_id) VALUES (2, 3);

-- Insert sample data into Shares
INSERT INTO Shares (post_id, user_id) VALUES (1, 3);
INSERT INTO Shares (post_id, user_id) VALUES (2, 1);

-- Verify Users
SELECT * FROM Users;

-- Verify Posts
SELECT * FROM Posts;

-- Verify Comments
SELECT * FROM Comments;

-- Verify Likes
SELECT * FROM Likes;

-- Verify Shares
SELECT * FROM Shares;


#User Engagement Metrics
SELECT
    Users.username,
    COUNT(DISTINCT Posts.post_id) AS posts_count,
    COUNT(DISTINCT Comments.comment_id) AS comments_count,
    COUNT(DISTINCT Likes.like_id) AS likes_count,
    COUNT(DISTINCT Shares.share_id) AS shares_count
FROM Users
LEFT JOIN Posts ON Users.user_id = Posts.user_id
LEFT JOIN Comments ON Users.user_id = Comments.user_id
LEFT JOIN Likes ON Users.user_id = Likes.user_id
LEFT JOIN Shares ON Users.user_id = Shares.user_id
GROUP BY Users.username;


#Most Liked Posts
SELECT
    Posts.post_id,
    Users.username AS author,
    Posts.content,
    COUNT(Likes.like_id) AS likes_count
FROM Posts
JOIN Users ON Posts.user_id = Users.user_id
LEFT JOIN Likes ON Posts.post_id = Likes.post_id
GROUP BY Posts.post_id, Users.username, Posts.content
ORDER BY likes_count DESC;


#Most Commented Posts
SELECT
    Posts.post_id,
    Users.username AS author,
    Posts.content,
    COUNT(Comments.comment_id) AS comments_count
FROM Posts
JOIN Users ON Posts.user_id = Users.user_id
LEFT JOIN Comments ON Posts.post_id = Comments.post_id
GROUP BY Posts.post_id, Users.username, Posts.content
ORDER BY comments_count DESC;


#Most Shared Posts
SELECT
    Posts.post_id,
    Users.username AS author,
    Posts.content,
    COUNT(Shares.share_id) AS shares_count
FROM Posts
JOIN Users ON Posts.user_id = Users.user_id
LEFT JOIN Shares ON Posts.post_id = Shares.post_id
GROUP BY Posts.post_id, Users.username, Posts.content
ORDER BY shares_count DESC;


#Content Interaction Patterns
SELECT
    Posts.post_id,
    Users.username AS post_author,
    Posts.content,
    COUNT(DISTINCT Comments.comment_id) AS comments_count,
    COUNT(DISTINCT Likes.like_id) AS likes_count,
    COUNT(DISTINCT Shares.share_id) AS shares_count
FROM Posts
JOIN Users ON Posts.user_id = Users.user_id
LEFT JOIN Comments ON Posts.post_id = Comments.post_id
LEFT JOIN Likes ON Posts.post_id = Likes.post_id
LEFT JOIN Shares ON Posts.post_id = Shares.post_id
GROUP BY Posts.post_id, Users.username, Posts.content
ORDER BY comments_count DESC, likes_count DESC, shares_count DESC;


 #User Activity Over Time
SELECT
    Users.username,
    Posts.created_at AS post_date,
    COUNT(DISTINCT Posts.post_id) AS posts_count,
    COUNT(DISTINCT Comments.comment_id) AS comments_count,
    COUNT(DISTINCT Likes.like_id) AS likes_count,
    COUNT(DISTINCT Shares.share_id) AS shares_count
FROM Users
LEFT JOIN Posts ON Users.user_id = Posts.user_id
LEFT JOIN Comments ON Users.user_id = Comments.user_id
LEFT JOIN Likes ON Users.user_id = Likes.user_id
LEFT JOIN Shares ON Users.user_id = Shares.user_id
GROUP BY Users.username, Posts.created_at
ORDER BY Posts.created_at DESC;


#Most Active Users
SELECT
    Users.username,
    COUNT(DISTINCT Posts.post_id) AS posts_count,
    COUNT(DISTINCT Comments.comment_id) AS comments_count,
    COUNT(DISTINCT Likes.like_id) AS likes_count,
    COUNT(DISTINCT Shares.share_id) AS shares_count,
    (COUNT(DISTINCT Posts.post_id) + COUNT(DISTINCT Comments.comment_id) + COUNT(DISTINCT Likes.like_id) + COUNT(DISTINCT Shares.share_id)) AS total_activity
FROM Users
LEFT JOIN Posts ON Users.user_id = Posts.user_id
LEFT JOIN Comments ON Users.user_id = Comments.user_id
LEFT JOIN Likes ON Users.user_id = Likes.user_id
LEFT JOIN Shares ON Users.user_id = Shares.user_id
GROUP BY Users.username
ORDER BY total_activity DESC;


