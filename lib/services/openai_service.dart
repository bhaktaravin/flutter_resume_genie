import 'dart:convert';
import 'package:openai_dart/openai_dart.dart';
import '../models/user_profile.dart';
import '../models/ai_models.dart';

class OpenAIService {
  late final OpenAIClient _client;
  static const String _apiKey =
      'your-openai-api-key-here'; // TODO: Move to environment variables

  OpenAIService() {
    _client = OpenAIClient(apiKey: _apiKey);
  }

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
      final completion = await _client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4'),
          messages: [
            ChatCompletionMessage.system(content: systemPrompt),
            ChatCompletionMessage.user(
              content: 'Parse this resume:\n\n$resumeText',
            ),
          ],
          temperature: 0.1,
          maxTokens: 2000,
        ),
      );

      final responseContent = completion.choices.first.message.content;
      if (responseContent == null) {
        throw Exception('No response from OpenAI');
      }

      final jsonData = json.decode(responseContent);
      return UserProfile.fromJson(jsonData);
    } catch (e) {
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
      final completion = await _client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4'),
          messages: [
            ChatCompletionMessage.system(content: systemPrompt),
            ChatCompletionMessage.user(content: userPrompt),
          ],
          temperature: 0.7,
          maxTokens: 800,
        ),
      );

      return completion.choices.first.message.content ??
          'Failed to generate cover letter';
    } catch (e) {
      throw Exception('Failed to generate cover letter: $e');
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
      final completion = await _client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4'),
          messages: [
            ChatCompletionMessage.system(content: systemPrompt),
            ChatCompletionMessage.user(content: userPrompt),
          ],
          temperature: 0.3,
          maxTokens: 1000,
        ),
      );

      final responseContent = completion.choices.first.message.content;
      if (responseContent == null) {
        throw Exception('No response from OpenAI');
      }

      final jsonData = json.decode(responseContent);

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

  // Generate skill gap analysis and recommendations
  Future<SkillGapAnalysis> analyzeSkillGap({
    required UserProfile userProfile,
    required String targetRole,
  }) async {
    const systemPrompt = '''
You are an AI career strategist. Analyze a user's current skills and provide recommendations for their target role.

Return a JSON object with this structure:
{
  "recommendedSkills": [
    {
      "skillName": "React.js",
      "category": "Frontend Development",
      "importance": 0.9,
      "reason": "Essential for modern frontend development",
      "learningResources": ["resource1", "resource2"],
      "estimatedLearningTime": 40,
      "difficulty": "Intermediate"
    }
  ],
  "industryTrends": [
    {
      "skillName": "AI/ML",
      "demandGrowth": 0.45,
      "salaryImpact": 0.25,
      "topCompanies": ["Google", "Microsoft"],
      "trendDescription": "Growing demand in AI integration"
    }
  ],
  "skillDemandScores": {
    "JavaScript": 0.95,
    "Python": 0.88
  },
  "aiInsights": "Detailed analysis and recommendations"
}
''';

    final userPrompt =
        '''
Analyze skill gap for target role: $targetRole

Current Skills: ${userProfile.skills?.join(', ')}
Experience: ${userProfile.workExperience?.map((e) => '${e.jobTitle}: ${e.technologies?.join(', ')}').join('\n')}
Education: ${userProfile.education?.map((e) => e.degree).join(', ')}
''';

    try {
      final completion = await _client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4'),
          messages: [
            ChatCompletionMessage.system(content: systemPrompt),
            ChatCompletionMessage.user(content: userPrompt),
          ],
          temperature: 0.4,
          maxTokens: 1500,
        ),
      );

      final responseContent = completion.choices.first.message.content;
      if (responseContent == null) {
        throw Exception('No response from OpenAI');
      }

      final jsonData = json.decode(responseContent);

      return SkillGapAnalysis(
        currentSkills: userProfile.skills ?? [],
        recommendedSkills: (jsonData['recommendedSkills'] as List)
            .map((e) => SkillRecommendation.fromJson(e))
            .toList(),
        industryTrends: (jsonData['industryTrends'] as List)
            .map((e) => IndustryTrend.fromJson(e))
            .toList(),
        skillDemandScores: Map<String, double>.from(
          jsonData['skillDemandScores'],
        ),
        aiInsights: jsonData['aiInsights'],
        analysisDate: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to analyze skill gap: $e');
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
        ChatCompletionMessage.system(content: systemPrompt),
        ...conversationHistory.map(
          (msg) => msg.isUser
              ? ChatCompletionMessage.user(content: msg.content)
              : ChatCompletionMessage.assistant(content: msg.content),
        ),
        ChatCompletionMessage.user(content: userMessage),
      ];

      final completion = await _client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4'),
          messages: messages,
          temperature: 0.7,
          maxTokens: 800,
        ),
      );

      return completion.choices.first.message.content ??
          'Sorry, I couldn\'t process your request. Please try again.';
    } catch (e) {
      throw Exception('Failed to chat with assistant: $e');
    }
  }

  // Optimize resume for specific job
  Future<ResumeOptimization> optimizeResume({
    required UserProfile userProfile,
    required String targetJobTitle,
    required String jobDescription,
  }) async {
    const systemPrompt = '''
You are an expert resume optimizer. Analyze a user's profile and optimize it for a specific job.

Return a JSON object with this structure:
{
  "optimizedContent": "Complete optimized resume text",
  "suggestions": [
    {
      "section": "Professional Summary",
      "suggestion": "Specific improvement suggestion",
      "reason": "Why this improvement helps",
      "priority": "high/medium/low"
    }
  ],
  "improvementScore": 0.85,
  "aiAnalysis": "Overall analysis and recommendations"
}
''';

    final userPrompt =
        '''
Optimize resume for: $targetJobTitle
Job Description: $jobDescription

Current Profile:
${json.encode(userProfile.toJson())}
''';

    try {
      final completion = await _client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4'),
          messages: [
            ChatCompletionMessage.system(content: systemPrompt),
            ChatCompletionMessage.user(content: userPrompt),
          ],
          temperature: 0.4,
          maxTokens: 2000,
        ),
      );

      final responseContent = completion.choices.first.message.content;
      if (responseContent == null) {
        throw Exception('No response from OpenAI');
      }

      final jsonData = json.decode(responseContent);

      return ResumeOptimization(
        originalContent: json.encode(userProfile.toJson()),
        optimizedContent: jsonData['optimizedContent'],
        suggestions: (jsonData['suggestions'] as List)
            .map((e) => OptimizationSuggestion.fromJson(e))
            .toList(),
        improvementScore: jsonData['improvementScore'].toDouble(),
        targetJobTitle: targetJobTitle,
        aiAnalysis: jsonData['aiAnalysis'],
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to optimize resume: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
