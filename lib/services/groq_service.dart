import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_profile.dart';
import '../models/ai_models.dart';

class GroqService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1';
  static String get _apiKey => dotenv.env['GROQ_API_KEY'] ?? '';

  // FREE models available on Groq
  static const String _defaultModel =
      'llama-3.1-70b-versatile'; // Best free model
  static const String _fastModel = 'llama-3.1-8b-instant'; // Fastest free model

  // Validate API key is available
  static bool get isConfigured => _apiKey.isNotEmpty;

  // Parse resume text and extract structured data
  Future<UserProfile> parseResumeText(String resumeText) async {
    const systemPrompt = '''
You are an expert resume parser. Extract structured information from the given resume text and return it as a JSON object with the following structure:

{
  "name": "Full Name",
  "email": "email@example.com",
  "phone": "phone number",
  "location": "city, state/country",
  "professionalSummary": "brief professional summary",
  "workExperience": [
    {
      "jobTitle": "Job Title",
      "company": "Company Name",
      "location": "Location",
      "startDate": "YYYY-MM-DD",
      "endDate": "YYYY-MM-DD or null if current",
      "isCurrentJob": boolean,
      "description": "Job description",
      "achievements": ["achievement 1", "achievement 2"],
      "technologies": ["tech1", "tech2"]
    }
  ],
  "education": [
    {
      "degree": "Degree Name",
      "institution": "Institution Name",
      "location": "Location",
      "startDate": "YYYY-MM-DD",
      "endDate": "YYYY-MM-DD",
      "gpa": "GPA if mentioned",
      "description": "Description if any",
      "relevantCourses": ["course1", "course2"]
    }
  ],
  "skills": ["skill1", "skill2", "skill3"],
  "certifications": ["cert1", "cert2"],
  "projects": [
    {
      "name": "Project Name",
      "description": "Project description",
      "technologies": ["tech1", "tech2"],
      "githubUrl": "github link if available",
      "liveUrl": "live demo link if available",
      "startDate": "YYYY-MM-DD",
      "endDate": "YYYY-MM-DD",
      "achievements": ["achievement1", "achievement2"]
    }
  ],
  "linkedinUrl": "linkedin profile url if available",
  "githubUrl": "github profile url if available",
  "portfolioUrl": "portfolio url if available"
}

Extract as much information as possible. If a field is not found, set it to null or empty array as appropriate.
''';

    try {
      final response = await _makeRequest(
        model: _defaultModel,
        messages: [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': 'Parse this resume:\n\n$resumeText'},
        ],
        maxTokens: 2000,
        temperature: 0.1,
      );

      final jsonData = json.decode(response);
      return UserProfile.fromJson(jsonData);
    } catch (e, stack) {
      print('GroqService.parseResumeText error:');
      print(e);
      print(stack);
      throw Exception('Failed to parse resume: $e');
    }
  }

  // Generate personalized cover letter
  Future<String> generateCoverLetter({
    required UserProfile userProfile,
    required String jobTitle,
    required String companyName,
    required String jobDescription,
  }) async {
    const systemPrompt = '''
You are an expert career coach and writer. Generate a personalized, professional cover letter based on the user's profile and the job they're applying for. 

The cover letter should:
1. Be engaging and personalized
2. Highlight relevant experience and skills
3. Show enthusiasm for the role and company
4. Be concise (3-4 paragraphs)
5. Include specific examples from their background
6. Match the tone to the industry

Format it as a proper cover letter with placeholders for [Date] and proper salutation.
''';

    final userPrompt =
        '''
Generate a cover letter for the following:

Job Title: $jobTitle
Company: $companyName
Job Description: $jobDescription

User Profile:
Name: ${userProfile.name}
Professional Summary: ${userProfile.professionalSummary}
Skills: ${userProfile.skills?.join(', ')}
Work Experience: ${userProfile.workExperience?.map((e) => '${e.jobTitle} at ${e.company}').join(', ')}
Education: ${userProfile.education?.map((e) => '${e.degree} from ${e.institution}').join(', ')}
''';

    try {
      final response = await _makeRequest(
        model: _defaultModel,
        messages: [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': userPrompt},
        ],
        maxTokens: 800,
        temperature: 0.7,
      );

      return response;
    } catch (e) {
      throw Exception('Failed to generate cover letter: $e');
    }
  }

  // Chat with AI career assistant
  Future<String> chatWithAssistant({
    required String userMessage,
    required List<ChatMessage> conversationHistory,
    UserProfile? userProfile,
  }) async {
    final systemPrompt =
        '''
You are ResumeGenie, an expert AI career advisor and resume specialist. You help users with:
- Career advice and planning
- Resume optimization
- Interview preparation
- Job search strategies
- Skill development recommendations
- Industry insights

Be helpful, professional, and provide actionable advice. Keep responses concise but informative.
${userProfile != null ? '\nUser Profile Context:\nName: ${userProfile.name}\nSkills: ${userProfile.skills?.join(', ')}\nExperience: ${userProfile.workExperience?.map((e) => e.jobTitle).join(', ')}' : ''}
''';

    try {
      final messages = [
        {'role': 'system', 'content': systemPrompt},
        ...conversationHistory.map(
          (msg) => {
            'role': msg.isUser ? 'user' : 'assistant',
            'content': msg.content,
          },
        ),
        {'role': 'user', 'content': userMessage},
      ];

      final response = await _makeRequest(
        model: _fastModel, // Use faster model for chat
        messages: messages,
        maxTokens: 800,
        temperature: 0.7,
      );

      return response;
    } catch (e) {
      throw Exception('Failed to chat with assistant: $e');
    }
  }

  // Analyze job match and provide recommendations
  Future<JobRecommendation> analyzeJobMatch({
    required UserProfile userProfile,
    required String jobTitle,
    required String company,
    required String jobDescription,
    required List<String> requirements,
  }) async {
    const systemPrompt = '''
You are an AI career advisor. Analyze how well a user's profile matches a job posting and provide detailed insights.

Return a JSON object with this structure:
{
  "matchScore": 0.85,
  "matchingSkills": ["skill1", "skill2"],
  "missingSkills": ["skill3", "skill4"],
  "aiAnalysis": "Detailed analysis of the match, including strengths, gaps, and recommendations for improving candidacy"
}

The match score should be between 0.0 and 1.0, where 1.0 is a perfect match.
''';

    final userPrompt =
        '''
Analyze the job match for:

Job: $jobTitle at $company
Job Description: $jobDescription
Requirements: ${requirements.join(', ')}

User Profile:
Skills: ${userProfile.skills?.join(', ')}
Experience: ${userProfile.workExperience?.map((e) => '${e.jobTitle} at ${e.company}: ${e.description}').join('\n')}
Education: ${userProfile.education?.map((e) => '${e.degree} from ${e.institution}').join(', ')}
''';

    try {
      final response = await _makeRequest(
        model: _defaultModel,
        messages: [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': userPrompt},
        ],
        maxTokens: 1000,
        temperature: 0.3,
      );

      final jsonData = json.decode(response);

      return JobRecommendation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: jobTitle,
        company: company,
        location: 'Not specified',
        description: jobDescription,
        requirements: requirements,
        preferredSkills: [],
        salaryRange: 'Not specified',
        jobType: 'Not specified',
        experienceLevel: 'Not specified',
        matchScore: jsonData['matchScore'].toDouble(),
        matchingSkills: List<String>.from(jsonData['matchingSkills']),
        missingSkills: List<String>.from(jsonData['missingSkills']),
        aiAnalysis: jsonData['aiAnalysis'],
        postedDate: DateTime.now(),
        applyUrl: '',
      );
    } catch (e) {
      throw Exception('Failed to analyze job match: $e');
    }
  }

  // Make HTTP request to Groq API
  Future<String> _makeRequest({
    required String model,
    required List<Map<String, String>> messages,
    int maxTokens = 1000,
    double temperature = 0.7,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'Groq API key not found. Please add GROQ_API_KEY to your .env file.',
      );
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: json.encode({
        'model': model,
        'messages': messages,
        'max_tokens': maxTokens,
        'temperature': temperature,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Groq API error: ${response.statusCode} - ${response.body}',
      );
    }

    final data = json.decode(response.body);
    return data['choices'][0]['message']['content'];
  }
}

// Alternative: Google Gemini Flash (also very cheap)
class GeminiService {
  // Implementation similar to above but using Gemini API
  // Cost: $0.075/1M input tokens, $0.30/1M output tokens
  // To use Gemini, add your API key to .env file as GEMINI_API_KEY=your_key_here
  static String get apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static bool get isConfigured => apiKey.isNotEmpty;
}
