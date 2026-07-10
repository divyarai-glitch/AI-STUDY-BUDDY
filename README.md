# 📚 AI Study Buddy

An AI-powered study companion that turns your PDF notes into summaries, quizzes, and an interactive chatbot — so you can learn faster and retain more.

Upload your lecture notes or textbook PDFs, and let AI do the heavy lifting: get instant summaries, auto-generated quizzes to test yourself, and a chatbot that answers questions **grounded strictly in your own notes** — no generic, made-up answers.

---

## ✨ Features

- **📤 PDF Upload** — Upload your notes as PDFs, stored securely via Cloudinary with extracted text saved to Firestore.
- **🧠 AI Summaries** — Get clear, concise, bullet-point summaries of your notes powered by Google Gemini.
- **📝 Auto-Generated Quizzes** — Instantly generate multiple-choice quizzes based on your notes, with a live timer, scoring, and instant feedback.
- **💬 RAG-Powered Chatbot** — Ask questions about your notes and get answers grounded in your actual content (Retrieval-Augmented Generation) — not generic AI responses.
- **📊 Progress Dashboard** — Track total notes uploaded, quizzes taken, and average scores at a glance.
- **🔔 Push Notifications** — Get notified when your summary/quiz is ready, plus daily motivational reminders via Firebase Cloud Messaging.
- **🔐 Secure Authentication** — Firebase Authentication with backend-side ID token verification on every request.

---

## 🛠️ Tech Stack

**Frontend**
- Flutter (Dart) — cross-platform mobile & web app
- Firebase Auth, Cloud Firestore, Firebase Cloud Messaging
- `http`, `file_picker`, `url_launcher`

**Backend**
- Spring Boot (Java 21)
- Google Gemini API — summaries, quiz generation, RAG chatbot responses
- Custom lightweight RAG pipeline — chunking + Gemini embeddings + cosine similarity retrieval
- Apache PDFBox — PDF text extraction
- Cloudinary — PDF file storage
- Firebase Admin SDK — Firestore database + Auth token verification + FCM push notifications

---

## 🏗️ Architecture

```
Flutter App
   │
   ├── Upload PDF ──────────► Spring Boot Backend
   │                                │
   │                                ├── Extract text (PDFBox)
   │                                ├── Store PDF (Cloudinary)
   │                                ├── Save note (Firestore)
   │                                └── Chunk + embed for RAG (Gemini Embeddings)
   │
   ├── Request Summary ─────► Gemini generates summary ─► cached in Firestore
   ├── Request Quiz ────────► Gemini generates MCQs ────► cached in Firestore
   └── Chat with Notes ─────► RAG retrieval + Gemini ───► grounded, note-specific answers
                                     │
                                     └── FCM notification on completion
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.x+)
- Java 21+
- Maven
- A Firebase project (Auth, Firestore, Cloud Messaging enabled)
- A free Gemini API key from [Google AI Studio](https://aistudio.google.com/apikey)
- A free Cloudinary account

### Backend Setup
```bash
cd backend
# Add your Firebase service account key to src/main/resources/serviceAccountKey.json
# Configure src/main/resources/application.properties with your API keys
mvn clean install
mvn spring-boot:run
```

### Frontend Setup
```bash
cd frontend
flutter pub get
flutter run -d chrome   # or your target device
```

### Environment Configuration

`application.properties` (backend):
```properties
gemini.api-key=YOUR_GEMINI_API_KEY
cloudinary.cloud-name=YOUR_CLOUD_NAME
cloudinary.api-key=YOUR_API_KEY
cloudinary.api-secret=YOUR_API_SECRET
```

> ⚠️ Never commit `serviceAccountKey.json` or real API keys — see `.gitignore`.

---

## 📱 Screens

| Screen | Description |
|---|---|
| **Notes Library** | Browse and search uploaded notes in a card grid |
| **Upload** | Pick and upload a PDF with title/subject |
| **Summary** | AI-generated summary with key points |
| **Quiz** | Timed multiple-choice quiz with live scoring |
| **Chat** | RAG-powered Q&A grounded in your notes |
| **Dashboard** | Study stats, streaks, and quiz history |

---

## 🔒 Security

- All API requests are authenticated via Firebase ID tokens verified server-side.
- User data is scoped per-user (`userId`) in Firestore with matching security rules.
- No sensitive credentials are stored in the repository.

---

## 📄 License

This project is for educational purposes.

---

## 🙌 Acknowledgements

Built with Flutter, Spring Boot, Google Gemini, Firebase, and Cloudinary.
