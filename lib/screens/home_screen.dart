import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
import '../providers/app_providers.dart';
import '../services/document_processing_service.dart';
import 'resume_preview_screen.dart';
import 'ai_chat_screen.dart';
// import 'profile_screen.dart';
// import 'job_recommendations_screen.dart';
// import 'skill_analysis_screen.dart';
import 'resume_builder_screen.dart';
import '../widgets/settings_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const _HomeTab();
  }
}

class _HomeTab extends ConsumerWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final loadingState = ref.watch(loadingStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('ResumeGenie'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const SettingsDialog(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context, userProfile),
            const SizedBox(height: 24),
            _buildQuickActions(context, ref, loadingState, userProfile),
            const SizedBox(height: 24),
            _buildAIFeatures(context),
            const SizedBox(height: 24),
            _buildRecentActivity(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, dynamic userProfile) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userProfile?.name != null
                  ? 'Welcome back, ${userProfile.name}!'
                  : 'Welcome to ResumeGenie!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              userProfile != null
                  ? 'Your AI career assistant is ready to help you land your dream job.'
                  : 'Let\'s get started by uploading your resume or creating a new profile.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    WidgetRef ref,
    Map<String, bool> loadingState,
    dynamic userProfile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 340, // Adjust as needed for your design
          child: AnimationLimiter(
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  _buildActionCard(
                    context,
                    'Upload Resume',
                    Icons.upload_file,
                    'Parse your existing resume with AI',
                    () => _uploadResume(context, ref),
                    isLoading: loadingState['upload_resume'] ?? false,
                  ),
                  _buildActionCard(
                    context,
                    'Try Sample Data',
                    Icons.psychology,
                    'Explore features with demo profile',
                    () => _loadSampleData(ref),
                  ),
                  _buildActionCard(
                    context,
                    'AI Chat',
                    Icons.chat,
                    'Get career advice from AI',
                    () => _navigateToChat(context),
                  ),
                  _buildActionCard(
                    context,
                    'Build Resume',
                    Icons.description,
                    'Create a new resume',
                    () => _navigateToResumeBuilder(context),
                  ),
                  _buildActionCard(
                    context,
                    'Preview Resume',
                    Icons.picture_as_pdf,
                    'View your resume PDF',
                    () {
                      if (userProfile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'No user profile found. Please upload or create a resume first.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ResumePreviewScreen(userProfile: userProfile),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap, {
    bool isLoading = false,
  }) {
    return Card(
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const CircularProgressIndicator()
              else
                Icon(
                  icon,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIFeatures(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI-Powered Features',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildFeatureList(context),
      ],
    );
  }

  Widget _buildFeatureList(BuildContext context) {
    final features = [
      {
        'icon': Icons.psychology,
        'title': 'Smart Resume Parsing',
        'description': 'AI extracts and structures data from any resume format',
      },
      {
        'icon': Icons.work_outline,
        'title': 'Job Matching Engine',
        'description': 'Find jobs that match your skills and experience',
      },
      {
        'icon': Icons.trending_up,
        'title': 'Skill Gap Analysis',
        'description': 'Identify skills to learn for career advancement',
      },
      {
        'icon': Icons.auto_fix_high,
        'title': 'Resume Optimization',
        'description': 'AI-powered suggestions to improve your resume',
      },
    ];

    return Column(
      children: features
          .map(
            (feature) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.1),
                  child: Icon(
                    feature['icon'] as IconData,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(
                  feature['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(feature['description'] as String),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Navigate to specific feature
                },
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(
                  Icons.timeline,
                  size: 48,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No recent activity',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload a resume or start using AI features to see your activity here.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _uploadResume(BuildContext context, WidgetRef ref) async {
    final loadingNotifier = ref.read(loadingStateProvider.notifier);
    final userProfileNotifier = ref.read(userProfileProvider.notifier);
    final errorNotifier = ref.read(errorProvider.notifier);
    final documentService = ref.read(documentProcessingServiceProvider);

    try {
      loadingNotifier.setLoading('upload_resume', true);
      errorNotifier.clearError();

      final profile = await documentService.pickAndProcessResume();

      if (profile != null) {
        userProfileNotifier.setProfile(profile);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Resume uploaded and parsed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        errorNotifier.setError('Failed to parse resume. Please try again.');
      }
    } catch (e) {
      errorNotifier.setError('Error uploading resume: $e');
    } finally {
      loadingNotifier.setLoading('upload_resume', false);
    }
  }

  void _loadSampleData(WidgetRef ref) {
    final userProfileNotifier = ref.read(userProfileProvider.notifier);
    final sampleProfile = SampleResumeData.getSampleProfile();
    userProfileNotifier.setProfile(sampleProfile);
  }

  void _navigateToChat(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AIchatScreen()));
  }

  void _navigateToResumeBuilder(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ResumeBuilderScreen()),
    );
  }
}
