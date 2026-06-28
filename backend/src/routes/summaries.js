const express = require('express');
const router = express.Router();
const db = require('../config/db');
const verifyToken = require('../middleware/auth');

// POST /api/summaries - Save summary
router.post('/', verifyToken, (req, res) => {
  const { note_id, summary_text, length_type } = req.body;
  const user_id = req.userId;

  if (!note_id || !summary_text) {
    return res.status(400).json({ message: 'note_id and summary_text are required' });
  }

  const sql = 'INSERT INTO summaries (user_id, note_id, summary_text, length_type) VALUES (?, ?, ?, ?)';
  db.query(sql, [user_id, note_id, summary_text, length_type || 'short'], (err, result) => {
    if (err) return res.status(500).json({ message: 'Failed to save summary' });
    res.status(201).json({ message: 'Summary saved successfully', summaryId: result.insertId });
  });
});

// GET /api/summaries - Get all summaries of user
router.get('/', verifyToken, (req, res) => {
  const user_id = req.userId;

  const sql = `SELECT summaries.*, notes.title as note_title 
               FROM summaries 
               JOIN notes ON summaries.note_id = notes.id 
               WHERE summaries.user_id = ? 
               ORDER BY generated_at DESC`;

  db.query(sql, [user_id], (err, results) => {
    if (err) return res.status(500).json({ message: 'Failed to fetch summaries' });
    res.status(200).json({ summaries: results });
  });
});

// GET /api/summaries/:id - Get single summary
router.get('/:id', verifyToken, (req, res) => {
  const { id } = req.params;
  const user_id = req.userId;

  const sql = 'SELECT * FROM summaries WHERE id = ? AND user_id = ?';
  db.query(sql, [id, user_id], (err, results) => {
    if (err) return res.status(500).json({ message: 'Failed to fetch summary' });
    if (results.length === 0) return res.status(404).json({ message: 'Summary not found' });
    res.status(200).json({ summary: results[0] });
  });
});

// DELETE /api/summaries/:id - Delete summary
router.delete('/:id', verifyToken, (req, res) => {
  const { id } = req.params;
  const user_id = req.userId;

  const sql = 'DELETE FROM summaries WHERE id = ? AND user_id = ?';
  db.query(sql, [id, user_id], (err, result) => {
    if (err) return res.status(500).json({ message: 'Failed to delete summary' });
    if (result.affectedRows === 0) return res.status(404).json({ message: 'Summary not found' });
    res.status(200).json({ message: 'Summary deleted successfully' });
  });
});

module.exports = router;