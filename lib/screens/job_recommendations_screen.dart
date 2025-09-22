import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ai_models.dart';
import '../providers/app_providers.dart';

class JobRecommendationsScreen extends ConsumerWidget {
  const JobRecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final jobRecommendations = ref.watch(jobRecommendationsProvider);
    final loadingState = ref.watch(loadingStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Recommendations'),
        actions: [
          if (userProfile != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _generateRecommendations(context, ref),
            ),
        ],
      ),
      body: userProfile == null
          ? _buildEmptyState(context, ref)
          : jobRecommendations.isEmpty
          ? _buildNoRecommendations(context, ref, loadingState)
          : _buildRecommendationsList(context, jobRecommendations),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline,
              size: 80,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No Profile Available',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Upload your resume or create a profile to get personalized job recommendations.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.person_add),
              label: const Text('Set Up Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoRecommendations(
    BuildContext context,
    WidgetRef ref,
    Map<String, bool> loadingState,
  ) {
    final isLoading = loadingState['job_recommendations'] ?? false;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                'Analyzing your profile...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'AI is finding the best job matches for you',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ] else ...[
              Icon(
                Icons.search,
                size: 80,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                'Ready for Job Recommendations',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Get AI-powered job recommendations based on your skills and experience.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => _generateRecommendations(context, ref),
                icon: const Icon(Icons.psychology),
                label: const Text('Get AI Recommendations'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsList(
    BuildContext context,
    List<JobRecommendation> recommendations,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        final job = recommendations[index];
        return _buildJobCard(context, job);
      },
    );
  }

  Widget _buildJobCard(BuildContext context, JobRecommendation job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showJobDetails(context, job),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.company,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  _buildMatchScore(context, job.matchScore),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    job.location,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    job.jobType,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                job.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              _buildSkillsMatch(context, job),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showJobDetails(context, job),
                      child: const Text('View Details'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _applyToJob(context, job),
                      child: const Text('Apply Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchScore(BuildContext context, double score) {
    final percentage = (score * 100).round();
    Color color;

    if (percentage >= 80) {
      color = Colors.green;
    } else if (percentage >= 60) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$percentage% Match',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSkillsMatch(BuildContext context, JobRecommendation job) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (job.matchingSkills.isNotEmpty) ...[
          Text(
            'Matching Skills:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: job.matchingSkills
                .take(5)
                .map(
                  (skill) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
        if (job.missingSkills.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Skills to Learn:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: job.missingSkills
                .take(3)
                .map(
                  (skill) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  void _showJobDetails(BuildContext context, JobRecommendation job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      job.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Text(
                job.company,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              _buildMatchScore(context, job.matchScore),
              const SizedBox(height: 24),
              Text(
                'Job Description',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(job.description),
              const SizedBox(height: 20),
              Text(
                'Requirements',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...job.requirements.map(
                (req) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(child: Text(req)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'AI Analysis',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(job.aiAnalysis),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _applyToJob(context, job),
                child: const Text('Apply for this Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generateRecommendations(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final loadingNotifier = ref.read(loadingStateProvider.notifier);
    final jobNotifier = ref.read(jobRecommendationsProvider.notifier);

    try {
      loadingNotifier.setLoading('job_recommendations', true);

      // Simulate AI processing
      await Future.delayed(const Duration(seconds: 3));

      // Generate sample recommendations
      final sampleJobs = _generateSampleJobs();
      jobNotifier.setRecommendations(sampleJobs);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job recommendations generated!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating recommendations: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      loadingNotifier.setLoading('job_recommendations', false);
    }
  }

  List<JobRecommendation> _generateSampleJobs() {
    return [
      JobRecommendation(
        id: '1',
        title: 'Senior Flutter Developer',
        company: 'TechCorp Inc.',
        location: 'San Francisco, CA',
        description:
            'We are looking for an experienced Flutter developer to join our mobile team. You will be responsible for developing cross-platform mobile applications with a focus on performance and user experience.',
        requirements: [
          '5+ years of mobile development experience',
          'Expert knowledge of Flutter and Dart',
          'Experience with Firebase and REST APIs',
          'Knowledge of mobile app architecture patterns',
        ],
        preferredSkills: ['Flutter', 'Dart', 'Firebase', 'REST APIs'],
        salaryRange: '\$120,000 - \$160,000',
        jobType: 'Full-time',
        experienceLevel: 'Senior',
        matchScore: 0.92,
        matchingSkills: ['Flutter', 'Dart', 'Firebase', 'Mobile Development'],
        missingSkills: ['Kotlin', 'Swift'],
        aiAnalysis:
            'Excellent match! Your Flutter and mobile development experience aligns perfectly with this role. Consider learning Kotlin and Swift to become an even stronger candidate for cross-platform development roles.',
        postedDate: DateTime.now().subtract(const Duration(days: 2)),
        applyUrl: 'https://example.com/apply/1',
      ),
      JobRecommendation(
        id: '2',
        title: 'AI/ML Engineer',
        company: 'InnovateLabs',
        location: 'Remote',
        description:
            'Join our AI team to build cutting-edge machine learning solutions. You will work on developing AI models, implementing ML pipelines, and integrating AI capabilities into our products.',
        requirements: [
          '3+ years of ML/AI experience',
          'Strong Python programming skills',
          'Experience with TensorFlow or PyTorch',
          'Knowledge of machine learning algorithms',
        ],
        preferredSkills: [
          'Python',
          'TensorFlow',
          'PyTorch',
          'Machine Learning',
        ],
        salaryRange: '\$100,000 - \$140,000',
        jobType: 'Full-time',
        experienceLevel: 'Mid-level',
        matchScore: 0.78,
        matchingSkills: ['Python', 'Machine Learning', 'TensorFlow'],
        missingSkills: ['PyTorch', 'Deep Learning', 'MLOps'],
        aiAnalysis:
            'Good match with your technical background. Your Python and ML experience is valuable. Consider strengthening your deep learning and MLOps skills to increase your competitiveness in AI roles.',
        postedDate: DateTime.now().subtract(const Duration(days: 1)),
        applyUrl: 'https://example.com/apply/2',
      ),
      JobRecommendation(
        id: '3',
        title: 'Full Stack Developer',
        company: 'StartupXYZ',
        location: 'New York, NY',
        description:
            'We need a versatile full-stack developer to work on both frontend and backend development. You will be building web applications using modern technologies and frameworks.',
        requirements: [
          '4+ years of full-stack development',
          'Experience with React and Node.js',
          'Knowledge of databases and APIs',
          'Familiarity with cloud platforms',
        ],
        preferredSkills: ['React', 'Node.js', 'JavaScript', 'AWS'],
        salaryRange: '\$90,000 - \$120,000',
        jobType: 'Full-time',
        experienceLevel: 'Mid-level',
        matchScore: 0.85,
        matchingSkills: ['React', 'Node.js', 'JavaScript', 'AWS'],
        missingSkills: ['GraphQL', 'Docker'],
        aiAnalysis:
            'Strong match for your full-stack skills. Your React and Node.js experience is exactly what they\'re looking for. Learning GraphQL and Docker would make you an even stronger candidate.',
        postedDate: DateTime.now().subtract(const Duration(days: 3)),
        applyUrl: 'https://example.com/apply/3',
      ),
    ];
  }

  void _applyToJob(BuildContext context, JobRecommendation job) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied to ${job.title} at ${job.company}'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
