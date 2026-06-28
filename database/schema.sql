-- AI Note Summarizer Database Schema
-- Team: CSE4104-7C-T06
-- Course: CSE 4104, Section: 7C

CREATE DATABASE IF NOT EXISTS ai_note_summarizer;
USE ai_note_summarizer;

-- Users Table
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('student', 'admin') DEFAULT 'student',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notes Table
CREATE TABLE notes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  title VARCHAR(200),
  content TEXT NOT NULL,
  input_type ENUM('text', 'file') DEFAULT 'text',
  uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Summaries Table
CREATE TABLE summaries (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  note_id INT NOT NULL,
  summary_text TEXT NOT NULL,
  length_type ENUM('short', 'medium', 'detailed') DEFAULT 'short',
  generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE
);