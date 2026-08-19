# AI Note Summarizer
### CSE4104-7C-T06 | Section: 7C | Northern University of Business & Technology, Khulna

---

## Project Overview
AI Note Summarizer is a web-based academic assistant designed for students. It uses **Google Gemini AI** to convert lengthy lecture notes, PDFs, and study materials into concise, structured summaries — saving students valuable study time.

---

## Team Members
| Name | Student ID | Role |
|---|---|---|
| Jinat Rafia Jeba | 11230121069 | Team Leader |
| Md. Rasik Zaman | 11230121163 | Member |
| Sheikh Shamun Ishmam | 11230121148 | Member |

---

## Tech Stack
| Layer | Technology |
|---|---|
| Frontend | Flutter (Dart) |
| Backend | Node.js + Express.js |
| Database | MySQL 8.0 |
| AI | Google Gemini AI (gemini-1.5-flash) |
| Authentication | JWT + bcrypt |

---

## AI Integration
- **Platform:** Google Gemini AI
- **Model:** gemini-1.5-flash
- **Feature:** Intelligent note summarization
- **Prompt Engineering:** Custom academic prompts for Short, Medium, and Detailed summaries
- **Error Handling:** Rate limits, network failures, invalid responses

---

## Features

### Student
- Register / Login / Logout
- Upload or paste notes
- Generate AI summary (Short / Medium / Detailed)
- View summary history
- Delete summaries
- Edit profile

### Admin
- View all users
- Monitor system activity
- View summary logs

---

## Project Structure

```
AI-Note-Summarizer/
├── frontend/          # Flutter app
├── backend/           # Node.js + Express API
├── database/          # MySQL schema
├── ai/                # Prompt examples
├── documentation/     # Reports
├── screenshots/       # App screenshots
└── README.md
```

---

## API Endpoints
| Method | Endpoint | Description |
|---|---|---|
| POST | /api/auth/register | Register user |
| POST | /api/auth/login | Login user |
| POST | /api/notes | Save note |
| GET | /api/notes | Get all notes |
| POST | /api/summaries | Save summary |
| GET | /api/summaries | Get all summaries |
| DELETE | /api/summaries/:id | Delete summary |

---

## Setup Instructions

### Backend
```
cd backend
npm install
node src/server.js
```

### Frontend
```
cd frontend
flutter pub get
flutter run
```

### Database
```
Run database/schema.sql in MySQL
```

---

## Environment Variables (.env)
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=ai_note_summarizer
JWT_SECRET=your_secret_key
PORT=5000
```

---

## GitHub Repository
https://github.com/Black-Shark69/AI-Note-Summarizer