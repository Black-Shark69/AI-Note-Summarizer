const express = require('express');
const router = express.Router();
const db = require('../config/db');
const verifyToken = require('../middleware/auth');

// POST /api/notes - Upload note
router.post('/', verifyToken, (req, res) => {
  const { title, content, input_type } = req.body;
  const user_id = req.userId;

  if (!content) {
    return res.status(400).json({ message: 'Content is required' });
  }

  const sql = 'INSERT INTO notes (user_id, title, content, input_type) VALUES (?, ?, ?, ?)';
  db.query(sql, [user_id, title, content, input_type || 'text'], (err, result) => {
    if (err) return res.status(500).json({ message: 'Failed to save note' });
    res.status(201).json({ message: 'Note saved successfully', noteId: result.insertId });
  });
});

// GET /api/notes - Get all notes of user
router.get('/', verifyToken, (req, res) => {
  const user_id = req.userId;

  const sql = 'SELECT * FROM notes WHERE user_id = ? ORDER BY uploaded_at DESC';
  db.query(sql, [user_id], (err, results) => {
    if (err) return res.status(500).json({ message: 'Failed to fetch notes' });
    res.status(200).json({ notes: results });
  });
});

// DELETE /api/notes/:id - Delete a note
router.delete('/:id', verifyToken, (req, res) => {
  const { id } = req.params;
  const user_id = req.userId;

  const sql = 'DELETE FROM notes WHERE id = ? AND user_id = ?';
  db.query(sql, [id, user_id], (err, result) => {
    if (err) return res.status(500).json({ message: 'Failed to delete note' });
    if (result.affectedRows === 0) return res.status(404).json({ message: 'Note not found' });
    res.status(200).json({ message: 'Note deleted successfully' });
  });
});

module.exports = router;