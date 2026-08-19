# AI Prompt Examples — AI Note Summarizer

## Team: CSE4104-7C-T06

---

## AI Platform

* **Platform:** Google Gemini
* **Model:** gemini-1.5-flash
* **Purpose:** Academic note summarization for students

---

## Prompt 1 — Short Summary

### System Prompt

```text
You are an academic note summarizer for students.
Summarize the following educational content in maximum 80 words.
Keep the most important concepts, key points, and definitions.
Write in clear, simple English suitable for students.
Do not add any introduction like "Here is a summary" - just write the summary directly.
```

### User Prompt

```text
Content to summarize:
Machine learning is a subset of artificial intelligence that enables
systems to learn and improve from experience without being explicitly
programmed. It focuses on developing computer programs that can access
data and use it to learn for themselves...
```

### Expected Output

```text
Machine learning enables systems to learn from data without explicit
programming. It uses algorithms to identify patterns and improve
performance over time. Key types include supervised, unsupervised,
and reinforcement learning. Applications include image recognition,
natural language processing, and recommendation systems.
```

---

## Prompt 2 — Medium Summary

### System Prompt

```text
You are an academic note summarizer for students.
Summarize the following educational content in maximum 150 words.
Keep the most important concepts, key points, and definitions.
Write in clear, simple English suitable for students.
Do not add any introduction like "Here is a summary" - just write the summary directly.
```

### User Prompt

```text
Content to summarize:
[User's lecture notes or study material]
```

### Expected Output

```text
A medium-length structured summary covering all major topics,
key definitions, and important concepts from the input content.
```

---

## Prompt 3 — Detailed Summary

### System Prompt

```text
You are an academic note summarizer for students.
Summarize the following educational content in maximum 250 words.
Keep the most important concepts, key points, and definitions.
Write in clear, simple English suitable for students.
Do not add any introduction like "Here is a summary" - just write the summary directly.
```

### User Prompt

```text
Content to summarize:
[User's lecture notes or study material]
```

### Expected Output

```text
A comprehensive summary covering all topics in detail,
including definitions, examples, and key takeaways.
```

---

## AI Workflow

```text
User Input (note/text)
↓
Flutter Frontend
↓
Backend API (Node.js + Express)
↓
Gemini AI Service (gemini-1.5-flash)
↓
AI Response (summary text)
↓
Backend Processing (save to MySQL)
↓
Frontend Display (summary output)
```

---

## Error Handling

| Scenario            | Handling                          |
| ------------------- | --------------------------------- |
| Empty response      | Show "Could not generate summary" |
| Rate limit exceeded | Show retry message with wait time |
| Network failure     | Show connection error message     |
| Invalid token       | Redirect to login                 |
| API error           | Show friendly error message       |

---

## Current Limitations

* Free tier rate limits apply
* Bengali text summarization may be less accurate
* No file upload support yet (PDF/DOCX)

## Future Improvements

* Support PDF and DOCX file upload
* Multi-language summarization
* Key points extraction as bullet points
* Quiz generation from notes
