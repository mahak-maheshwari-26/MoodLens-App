# 🌟 MoodLens – Full-Stack AI-Powered Emotion Recognition & Reflective Journaling Platform

<p align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![PyTorch](https://img.shields.io/badge/PyTorch-EE4C2C?style=for-the-badge&logo=pytorch&logoColor=white)
![HuggingFace](https://img.shields.io/badge/Hugging_Face-FFD21E?style=for-the-badge&logo=huggingface&logoColor=black)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)

</p>

MoodLens is a **full-stack AI-powered journaling application** that helps users recognize, understand, and reflect on their emotions using **Natural Language Processing (NLP)**. Users can securely write journal entries, receive real-time AI emotion analysis, visualize mood trends, and monitor their emotional well-being over time.

The application integrates a **Flutter mobile frontend**, **FastAPI backend**, **fine-tuned DistilRoBERTa transformer model**, **PostgreSQL database**, and secure authentication to deliver a scalable and privacy-focused emotional wellness platform.

> **Disclaimer**
>
> MoodLens is intended for emotional self-reflection and wellness purposes only. It is **not** a substitute for professional psychological or medical advice.

---

# ⭐ Project Highlights

- 🤖 Fine-tuned **DistilRoBERTa** emotion classification model
- 🤗 AI model deployed on **Hugging Face Hub**
- 📱 Cross-platform Flutter mobile application
- ⚡ FastAPI REST backend
- 🐘 PostgreSQL relational database
- 🔐 Encrypted journal storage for enhanced privacy
- 🔑 JWT authentication with secure password hashing
- 📊 Interactive mood analytics and emotional trends
- 👨‍💼 Dedicated admin dashboard
- 🚀 Automatic model caching for faster inference
- ☁️ Hugging Face model loading (no local model storage required)

---

# ✨ Features

## 👤 User Features

- Secure user registration and login
- JWT-based authentication
- User profile management
- AI-powered emotion detection
- Daily reflective journaling
- Mood history tracking
- Emotion trend visualization
- Personalized positive recommendations
- Feedback submission

---

## 👨‍💼 Admin Features

- Secure admin authentication
- User management
- Feedback management
- Mood trend monitoring
- Dashboard statistics

---

# 🔐 Security Features

MoodLens prioritizes privacy and secure data management.

### Authentication

- JWT-based authentication
- Password hashing using secure cryptographic algorithms
- Role-based authorization (Admin & User)

### Data Security

- Encrypted journal entries before database storage
- Secure PostgreSQL database
- Protected REST API endpoints
- Authentication middleware
- User-specific journal access

---

# ⚡ Performance Optimizations

The backend is optimized for efficient inference.

- Transformer model loads only once during server startup.
- Hugging Face model is cached in RAM.
- Automatic memory cleanup during shutdown.
- GPU memory is released automatically when CUDA is available.
- Large model files are **not** stored in the repository.

---

# 🤖 AI Model

MoodLens leverages a **fine-tuned DistilRoBERTa transformer model** for multi-class emotion classification. The model analyzes user journal entries and predicts the dominant emotional state with a confidence score. When appropriate, it can also identify a meaningful secondary emotion.

## Model Details

| Feature | Description |
|---------|-------------|
| Base Model | DistilRoBERTa |
| Framework | Hugging Face Transformers |
| Deep Learning Framework | PyTorch |
| Task | Multi-Class Emotion Classification |
| Number of Classes | 7 |
| Deployment | Hugging Face Hub |
| Backend Integration | FastAPI Transformers Pipeline |

### 🤗 Hugging Face Model

The trained model is publicly hosted on Hugging Face and is automatically downloaded during backend startup.

**Model Repository**

```
https://huggingface.co/mahak-maheshwari-26/moodlens-nlp
```

### Supported Emotions

| Emotion | Emoji |
|---------|-------|
| Joy | 😊 |
| Sadness | 😢 |
| Anger | 😠 |
| Fear | 😨 |
| Guilt | 😞 |
| Shame | 😳 |
| Disgust | 🤢 |

---

# 📊 Dataset

The emotion classification model was fine-tuned using the **ISEAR (International Survey on Emotion Antecedents and Reactions)** dataset.

## Dataset Highlights

- Approximately **7,500** text samples
- Seven emotion categories
- Real-world emotional experiences
- High-quality manually labeled dataset
- Suitable for multi-class emotion classification

---

# 🏗️ System Architecture

```
                   Flutter Mobile Application
                              │
                              ▼
                    FastAPI REST Backend
                              │
          ┌───────────────────┴───────────────────┐
          │                                       │
          ▼                                       ▼
 Hugging Face DistilRoBERTa              PostgreSQL Database
 Emotion Classification                  (Encrypted Journals)
          │                                       │
          └───────────────────┬───────────────────┘
                              ▼
                   Mood Analytics Dashboard
                              │
                              ▼
                  Personalized Recommendations
```

---

# 📱 Application Modules

## 👤 Client Module

- User Registration
- User Login
- Profile Setup
- Dashboard
- Add Journal Entry
- AI Emotion Detection
- Mood Analytics
- Mood History
- Feedback Submission

---

## 👨‍💼 Admin Module

- Admin Login
- Dashboard
- User Management
- Feedback Management
- Mood Trend Analytics

---

# 🛠️ Tech Stack

## Frontend

- Flutter
- Dart

---

## Backend

- Python
- FastAPI
- SQLAlchemy
- Uvicorn

---

## AI & Machine Learning

- DistilRoBERTa
- Hugging Face Transformers
- PyTorch
- Hugging Face Hub

---

## Database

- PostgreSQL

---

## Authentication & Security

- JWT Authentication
- Password Hashing
- Role-Based Access Control
- Encrypted Journal Storage

---

## Development Tools

- Git
- GitHub
- Visual Studio Code


## 📂 Project Structure

```
MoodLens_Project/

│
├── admin_frontend/
|
├── flutter_frontend/
|
├── backend/
|   ├── models/
│   ├── routes/
|   ├── pydantic_schemas/
│   ├── database.py
│   ├── auth_utils.py
│   ├── main.py
│   ├── requirements.txt
│   └── .env.example
│   └── ...
│
├── model_script/
│
├── screenshots/
│
├── UML-Diagrams/
│
├── README.md

```

---

# 🚀 Getting Started

## Prerequisites

Install the following software before running the project:

- Python 3.10+
- Flutter SDK
- PostgreSQL
- pgAdmin 4
- Git

---

## Clone the Repository

```bash
git clone https://github.com/mahak-maheshwari-26/MoodLens-App.git

cd MoodLens-App
```

---

# 🐍 Backend Setup

Navigate to the backend directory.

```bash
cd backend
```

### Create a Virtual Environment

```bash
python -m venv .venv
```

Activate it.

**Windows**

```bash
.venv\Scripts\activate
```

**Linux/macOS**

```bash
source .venv/bin/activate
```

Install the required packages.

```bash
pip install -r requirements.txt
```

---

# ⚙️ Environment Variables

Create a file named **`.env`** inside the `backend` directory.

Example:

```env
DATABASE_URL=postgresql://username:password@localhost:5432/moodlens_db

SECRET_KEY=your_secret_key

ALGORITHM=HS256

ACCESS_TOKEN_EXPIRE_MINUTES=43200

ENCRYPTION_KEY=your_encryption_key
```

> **Important:** The `.env` file contains sensitive credentials and is **excluded from version control** using `.gitignore`. Only a `.env.example` template should be committed.

---

# 🐘 PostgreSQL Setup

1. Install PostgreSQL.
2. Create a database named:

```
moodlens_db
```

3. Update the `DATABASE_URL` in the `.env` file with your PostgreSQL username and password.

4. Use **pgAdmin 4** (optional) to manage the database visually.

> **Note:** pgAdmin is a database administration tool. The application uses **PostgreSQL** as its database engine.

---

# ▶️ Run the Backend

Start the FastAPI server.

```bash
uvicorn main:app --reload
```

The backend will:

- Create required database tables automatically.
- Create a default admin account if one does not exist.
- Download the latest NLP model from Hugging Face (first run only).
- Cache the model in memory for faster predictions.

---

# 📱 Flutter Setup

Navigate to the Flutter project.

```bash
cd flutter_frontend
```

Install Flutter packages.

```bash
flutter pub get
```

Run the application.

```bash
flutter run
```

---

# 🤖 AI Model Loading

The emotion classification model is **not stored inside this repository**.

During backend startup, FastAPI automatically downloads the latest version of the model from Hugging Face using the Transformers pipeline.

This approach:

- Keeps the repository lightweight.
- Makes model updates easier.
- Avoids committing large model files.
- Automatically caches the model after the first download.

---

# 🔌 Backend API Modules

The FastAPI backend exposes REST APIs for:

- Authentication
- User Profiles
- Journal Management
- Emotion Prediction
- Feedback
- Admin Dashboard

---

## 📈 Future Improvements

- 🎤 Voice Journaling
- 🎙️ Speech Emotion Recognition
- 🌍 Multi-language Support
- ☁️ Cloud Database Synchronization
- 📈 Advanced Mood Analytics
- 🧠 Personalized AI Wellness Suggestions
- 👨‍⚕️ Therapist Dashboard
- 📅 Mood Calendar & Timeline
- 🌙 Dark Mode
- 🔔 Daily Journal Reminder Notifications
- 📤 Journal Export (PDF)
- 📊 Weekly & Monthly Emotional Reports

---

# 📷 Screenshots

Screenshots demonstrating the application's user interface and workflow are available in the **`screenshots/`** directory.

---

## 📚 UML Diagrams

The project includes:

- Use Case Diagram
- Class Diagram
- Sequence Diagram
- Activity Diagram

---

# 🔒 Privacy & Ethics

MoodLens is designed with user privacy as a core principle.

- Journal entries are encrypted before being stored.
- Passwords are securely hashed.
- JWT authentication protects user sessions.
- Personal data is never shared with third parties.
- AI predictions are intended solely for emotional self-reflection.

> **Disclaimer:** MoodLens is an educational project and should not be considered a replacement for professional mental health care, diagnosis, or treatment.

---

# 📚 Dataset

The emotion classification model was fine-tuned using the **ISEAR Dataset**.

Dataset Repository:

https://huggingface.co/datasets/gsri-18/ISEAR-dataset-complete

---

## 👩‍💻 Authors

**Mahak Maheshwari**

---

## 🙏 Acknowledgements

- Hugging Face
- ISEAR Dataset
- Flutter Community
- FastAPI Community

---

## 📄 License

This project is developed for academic and educational purposes.

Please respect the licensing terms of the original dataset and pretrained models used in this project.