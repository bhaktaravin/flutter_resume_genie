import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../models/ai_models.dart';
import '../services/groq_service.dart';
import '../services/document_processing_service.dart';

// User profile provider
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
      return UserProfileNotifier();
    });

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier() : super(null);

  void setProfile(UserProfile profile) {
    state = profile;
  }

  void updateProfile(UserProfile profile) {
    state = profile.copyWith(lastUpdated: DateTime.now());
  }

  void clearProfile() {
    state = null;
  }
}

// Chat messages provider
final chatMessagesProvider =
    StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>((ref) {
      return ChatMessagesNotifier();
    });

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessagesNotifier() : super([]);

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }

  void clearMessages() {
    state = [];
  }
}

// Job recommendations provider
final jobRecommendationsProvider =
    StateNotifierProvider<JobRecommendationsNotifier, List<JobRecommendation>>((
      ref,
    ) {
      return JobRecommendationsNotifier();
    });

class JobRecommendationsNotifier
    extends StateNotifier<List<JobRecommendation>> {
  JobRecommendationsNotifier() : super([]);

  void setRecommendations(List<JobRecommendation> recommendations) {
    state = recommendations;
  }

  void addRecommendation(JobRecommendation recommendation) {
    state = [...state, recommendation];
  }

  void clearRecommendations() {
    state = [];
  }
}

// Skill gap analysis provider
final skillGapAnalysisProvider =
    StateNotifierProvider<SkillGapAnalysisNotifier, SkillGapAnalysis?>((ref) {
      return SkillGapAnalysisNotifier();
    });

class SkillGapAnalysisNotifier extends StateNotifier<SkillGapAnalysis?> {
  SkillGapAnalysisNotifier() : super(null);

  void setAnalysis(SkillGapAnalysis analysis) {
    state = analysis;
  }

  void clearAnalysis() {
    state = null;
  }
}

// Loading states provider
final loadingStateProvider =
    StateNotifierProvider<LoadingStateNotifier, Map<String, bool>>((ref) {
      return LoadingStateNotifier();
    });

class LoadingStateNotifier extends StateNotifier<Map<String, bool>> {
  LoadingStateNotifier() : super({});

  void setLoading(String key, bool isLoading) {
    state = {...state, key: isLoading};
  }

  bool isLoading(String key) {
    return state[key] ?? false;
  }
}

// Service providers
final groqServiceProvider = Provider<GroqService>((ref) {
  return GroqService();
});

final documentProcessingServiceProvider = Provider<DocumentProcessingService>((
  ref,
) {
  return DocumentProcessingService();
});

// Error provider
final errorProvider = StateNotifierProvider<ErrorNotifier, String?>((ref) {
  return ErrorNotifier();
});

class ErrorNotifier extends StateNotifier<String?> {
  ErrorNotifier() : super(null);

  void setError(String error) {
    state = error;
  }

  void clearError() {
    state = null;
  }
}

// Resume optimization provider
final resumeOptimizationProvider =
    StateNotifierProvider<ResumeOptimizationNotifier, ResumeOptimization?>((
      ref,
    ) {
      return ResumeOptimizationNotifier();
    });

class ResumeOptimizationNotifier extends StateNotifier<ResumeOptimization?> {
  ResumeOptimizationNotifier() : super(null);

  void setOptimization(ResumeOptimization optimization) {
    state = optimization;
  }

  void clearOptimization() {
    state = null;
  }
}
