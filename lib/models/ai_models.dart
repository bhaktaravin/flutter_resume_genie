class JobRecommendation {
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  final List<String> requirements;
  final List<String> preferredSkills;
  final String salaryRange;
  final String jobType;
  final String experienceLevel;
  final double matchScore;
  final List<String> matchingSkills;
  final List<String> missingSkills;
  final String aiAnalysis;
  final DateTime postedDate;
  final String applyUrl;

  JobRecommendation({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.requirements,
    required this.preferredSkills,
    required this.salaryRange,
    required this.jobType,
    required this.experienceLevel,
    required this.matchScore,
    required this.matchingSkills,
    required this.missingSkills,
    required this.aiAnalysis,
    required this.postedDate,
    required this.applyUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'description': description,
      'requirements': requirements,
      'preferredSkills': preferredSkills,
      'salaryRange': salaryRange,
      'jobType': jobType,
      'experienceLevel': experienceLevel,
      'matchScore': matchScore,
      'matchingSkills': matchingSkills,
      'missingSkills': missingSkills,
      'aiAnalysis': aiAnalysis,
      'postedDate': postedDate.toIso8601String(),
      'applyUrl': applyUrl,
    };
  }

  factory JobRecommendation.fromJson(Map<String, dynamic> json) {
    return JobRecommendation(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      description: json['description'],
      requirements: List<String>.from(json['requirements']),
      preferredSkills: List<String>.from(json['preferredSkills']),
      salaryRange: json['salaryRange'],
      jobType: json['jobType'],
      experienceLevel: json['experienceLevel'],
      matchScore: json['matchScore'].toDouble(),
      matchingSkills: List<String>.from(json['matchingSkills']),
      missingSkills: List<String>.from(json['missingSkills']),
      aiAnalysis: json['aiAnalysis'],
      postedDate: DateTime.parse(json['postedDate']),
      applyUrl: json['applyUrl'],
    );
  }
}

class SkillGapAnalysis {
  final List<String> currentSkills;
  final List<SkillRecommendation> recommendedSkills;
  final List<IndustryTrend> industryTrends;
  final Map<String, double> skillDemandScores;
  final String aiInsights;
  final DateTime analysisDate;

  SkillGapAnalysis({
    required this.currentSkills,
    required this.recommendedSkills,
    required this.industryTrends,
    required this.skillDemandScores,
    required this.aiInsights,
    required this.analysisDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentSkills': currentSkills,
      'recommendedSkills': recommendedSkills.map((e) => e.toJson()).toList(),
      'industryTrends': industryTrends.map((e) => e.toJson()).toList(),
      'skillDemandScores': skillDemandScores,
      'aiInsights': aiInsights,
      'analysisDate': analysisDate.toIso8601String(),
    };
  }

  factory SkillGapAnalysis.fromJson(Map<String, dynamic> json) {
    return SkillGapAnalysis(
      currentSkills: List<String>.from(json['currentSkills']),
      recommendedSkills: (json['recommendedSkills'] as List)
          .map((e) => SkillRecommendation.fromJson(e))
          .toList(),
      industryTrends: (json['industryTrends'] as List)
          .map((e) => IndustryTrend.fromJson(e))
          .toList(),
      skillDemandScores: Map<String, double>.from(json['skillDemandScores']),
      aiInsights: json['aiInsights'],
      analysisDate: DateTime.parse(json['analysisDate']),
    );
  }
}

class SkillRecommendation {
  final String skillName;
  final String category;
  final double importance;
  final String reason;
  final List<String> learningResources;
  final int estimatedLearningTime; // in hours
  final String difficulty;

  SkillRecommendation({
    required this.skillName,
    required this.category,
    required this.importance,
    required this.reason,
    required this.learningResources,
    required this.estimatedLearningTime,
    required this.difficulty,
  });

  Map<String, dynamic> toJson() {
    return {
      'skillName': skillName,
      'category': category,
      'importance': importance,
      'reason': reason,
      'learningResources': learningResources,
      'estimatedLearningTime': estimatedLearningTime,
      'difficulty': difficulty,
    };
  }

  factory SkillRecommendation.fromJson(Map<String, dynamic> json) {
    return SkillRecommendation(
      skillName: json['skillName'],
      category: json['category'],
      importance: json['importance'].toDouble(),
      reason: json['reason'],
      learningResources: List<String>.from(json['learningResources']),
      estimatedLearningTime: json['estimatedLearningTime'],
      difficulty: json['difficulty'],
    );
  }
}

class IndustryTrend {
  final String skillName;
  final double demandGrowth;
  final double salaryImpact;
  final List<String> topCompanies;
  final String trendDescription;

  IndustryTrend({
    required this.skillName,
    required this.demandGrowth,
    required this.salaryImpact,
    required this.topCompanies,
    required this.trendDescription,
  });

  Map<String, dynamic> toJson() {
    return {
      'skillName': skillName,
      'demandGrowth': demandGrowth,
      'salaryImpact': salaryImpact,
      'topCompanies': topCompanies,
      'trendDescription': trendDescription,
    };
  }

  factory IndustryTrend.fromJson(Map<String, dynamic> json) {
    return IndustryTrend(
      skillName: json['skillName'],
      demandGrowth: json['demandGrowth'].toDouble(),
      salaryImpact: json['salaryImpact'].toDouble(),
      topCompanies: List<String>.from(json['topCompanies']),
      trendDescription: json['trendDescription'],
    );
  }
}

class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final ChatMessageType type;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    required this.type,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString(),
      'metadata': metadata,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      type: ChatMessageType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => ChatMessageType.text,
      ),
      metadata: json['metadata'],
    );
  }
}

enum ChatMessageType {
  text,
  jobRecommendation,
  skillAnalysis,
  resumeOptimization,
  interviewPrep,
  careerAdvice,
}

class ResumeOptimization {
  final String originalContent;
  final String optimizedContent;
  final List<OptimizationSuggestion> suggestions;
  final double improvementScore;
  final String targetJobTitle;
  final String aiAnalysis;
  final DateTime createdAt;

  ResumeOptimization({
    required this.originalContent,
    required this.optimizedContent,
    required this.suggestions,
    required this.improvementScore,
    required this.targetJobTitle,
    required this.aiAnalysis,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'originalContent': originalContent,
      'optimizedContent': optimizedContent,
      'suggestions': suggestions.map((e) => e.toJson()).toList(),
      'improvementScore': improvementScore,
      'targetJobTitle': targetJobTitle,
      'aiAnalysis': aiAnalysis,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ResumeOptimization.fromJson(Map<String, dynamic> json) {
    return ResumeOptimization(
      originalContent: json['originalContent'],
      optimizedContent: json['optimizedContent'],
      suggestions: (json['suggestions'] as List)
          .map((e) => OptimizationSuggestion.fromJson(e))
          .toList(),
      improvementScore: json['improvementScore'].toDouble(),
      targetJobTitle: json['targetJobTitle'],
      aiAnalysis: json['aiAnalysis'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class OptimizationSuggestion {
  final String section;
  final String suggestion;
  final String reason;
  final OptimizationPriority priority;
  final bool isImplemented;

  OptimizationSuggestion({
    required this.section,
    required this.suggestion,
    required this.reason,
    required this.priority,
    this.isImplemented = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'section': section,
      'suggestion': suggestion,
      'reason': reason,
      'priority': priority.toString(),
      'isImplemented': isImplemented,
    };
  }

  factory OptimizationSuggestion.fromJson(Map<String, dynamic> json) {
    return OptimizationSuggestion(
      section: json['section'],
      suggestion: json['suggestion'],
      reason: json['reason'],
      priority: OptimizationPriority.values.firstWhere(
        (e) => e.toString() == json['priority'],
        orElse: () => OptimizationPriority.medium,
      ),
      isImplemented: json['isImplemented'] ?? false,
    );
  }
}

enum OptimizationPriority { high, medium, low }
