# ResumeGenie - AI-Powered Career Assistant

## 🚀 Overview

ResumeGenie is a comprehensive Flutter mobile application that showcases advanced AI capabilities for career development. Built as a portfolio project to demonstrate modern mobile development skills and AI integration.

## ✨ Features

### 🤖 AI-Powered Core Features
- **Smart Resume Parsing**: Extract structured data from PDF resumes using AI
- **Interactive Career Assistant**: Chat with an AI career advisor for personalized guidance
- **Job Matching Engine**: Analyze job compatibility with detailed scoring and recommendations
- **Intelligent Cover Letter Generation**: Create personalized cover letters for specific positions
- **Skill Gap Analysis**: Identify missing skills and get learning recommendations

### 📱 Technical Highlights
- **Cross-Platform**: Built with Flutter for iOS and Android
- **Modern UI**: Material Design 3 with dark/light theme support
- **State Management**: Riverpod for reactive, scalable state management
- **Local Storage**: Hive database for offline data persistence
- **API Integration**: Groq AI API (free alternative to OpenAI)
- **Document Processing**: PDF parsing and text extraction
- **Security**: Environment-based API key management

## 🛠️ Technology Stack

- **Framework**: Flutter 3.8+
- **State Management**: Riverpod 2.5+
- **AI Service**: Groq API (free GPT-4 level performance)
- **Database**: Hive (local NoSQL database)
- **PDF Processing**: Syncfusion Flutter PDF
- **HTTP Client**: Standard HTTP package
- **Environment Management**: flutter_dotenv

## 📋 Prerequisites

- Flutter SDK 3.8 or higher
- Dart SDK 3.0 or higher
- iOS Simulator / Android Emulator or physical device
- Free Groq API account (sign up at [groq.com](https://groq.com))

## 🚀 Quick Setup

### 1. Clone and Setup
```bash
git clone <your-repo-url>
cd resume_genie
flutter pub get
```

### 2. Environment Configuration
```bash
# Copy the example environment file
cp .env.example .env

# Edit .env file and add your Groq API key
# GROQ_API_KEY=gsk_your_actual_api_key_here
```

### 3. Get Your Free Groq API Key
1. Visit [groq.com](https://groq.com)
2. Sign up for a free account
3. Navigate to API Keys section
4. Generate a new API key
5. Add it to your `.env` file

### 4. Run the App
```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user_profile.dart     # User profile with Hive annotations
│   └── ai_models.dart        # AI response models
├── screens/                  # UI screens
│   ├── home_screen.dart      # Dashboard with quick actions
│   ├── ai_chat_screen.dart   # Interactive AI assistant
│   ├── profile_screen.dart   # User profile management
│   ├── job_recommendations_screen.dart  # Job matching
│   └── skill_analysis_screen.dart       # Skill gap analysis
├── services/                 # Business logic
│   ├── groq_service.dart     # AI API integration
│   └── document_processing_service.dart # PDF processing
├── providers/                # State management
│   └── app_providers.dart    # Riverpod providers
└── widgets/                  # Reusable components
    ├── chat_message_widget.dart
    └── typing_indicator.dart
```

## 🔐 Security & Best Practices

- ✅ API keys stored in environment variables
- ✅ .env file excluded from version control
- ✅ Input validation and error handling
- ✅ Secure HTTP requests with proper headers
- ✅ No hardcoded sensitive information

## 🎯 Key AI Capabilities Demonstrated

### 1. Natural Language Processing
- Resume text extraction and structuring
- Conversation context management
- Intelligent job requirement analysis

### 2. Data Analysis & Matching
- Skills compatibility scoring
- Gap analysis with actionable insights
- Personalized recommendations

### 3. Content Generation
- Dynamic cover letter creation
- Career advice generation
- Professional summary optimization

## 💡 Why This Project?

This app demonstrates:
- **Full-stack mobile development** with modern Flutter practices
- **AI integration** using cost-effective solutions
- **Scalable architecture** with proper state management
- **Professional UI/UX** with Material Design 3
- **Production-ready code** with proper error handling and security

## 🚀 Future Enhancements

- [ ] Interview preparation module
- [ ] ATS optimization scoring
- [ ] Integration with job boards
- [ ] Resume builder with templates
- [ ] Career progression tracking
- [ ] Multi-language support

## 🤝 Contributing

This is a portfolio project, but feedback and suggestions are welcome! Feel free to:
- Open issues for bugs or feature requests
- Submit pull requests for improvements
- Share feedback on the architecture or UI/UX

## 📄 License

This project is created for educational and portfolio purposes. Feel free to use it as inspiration for your own projects.

---

**Built with ❤️ using Flutter and AI**

*This project showcases modern mobile development practices and AI integration capabilities suitable for production applications.*
# flutter_resume_genie
