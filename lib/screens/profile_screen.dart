import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../providers/app_providers.dart';
import '../services/document_processing_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (userProfile != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editProfile(context, ref),
            ),
        ],
      ),
      body: userProfile == null
          ? _buildEmptyState(context, ref)
          : _buildProfileContent(context, userProfile),
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
              Icons.person_outline,
              size: 80,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No Profile Yet',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Upload your resume or create a profile to get started with AI-powered career assistance.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _uploadResume(context, ref),
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Resume'),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _loadSampleData(ref),
              icon: const Icon(Icons.psychology),
              label: const Text('Try Sample Data'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(context, profile),
          const SizedBox(height: 24),
          _buildContactInfo(context, profile),
          const SizedBox(height: 24),
          _buildProfessionalSummary(context, profile),
          const SizedBox(height: 24),
          _buildWorkExperience(context, profile),
          const SizedBox(height: 24),
          _buildEducation(context, profile),
          const SizedBox(height: 24),
          _buildSkills(context, profile),
          const SizedBox(height: 24),
          _buildProjects(context, profile),
          const SizedBox(height: 24),
          _buildCertifications(context, profile),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProfile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                profile.name?.substring(0, 1).toUpperCase() ?? 'U',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name ?? 'No Name',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (profile.location != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          profile.location!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ],
                  if (profile.lastUpdated != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Updated ${_formatDate(profile.lastUpdated!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, UserProfile profile) {
    if (profile.email == null && profile.phone == null)
      return const SizedBox.shrink();

    return _buildSection(
      context,
      'Contact Information',
      Icons.contact_phone,
      Column(
        children: [
          if (profile.email != null)
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(profile.email!),
              contentPadding: EdgeInsets.zero,
            ),
          if (profile.phone != null)
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(profile.phone!),
              contentPadding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }

  Widget _buildProfessionalSummary(BuildContext context, UserProfile profile) {
    if (profile.professionalSummary == null) return const SizedBox.shrink();

    return _buildSection(
      context,
      'Professional Summary',
      Icons.description,
      Text(
        profile.professionalSummary!,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildWorkExperience(BuildContext context, UserProfile profile) {
    if (profile.workExperience == null || profile.workExperience!.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildSection(
      context,
      'Work Experience',
      Icons.work,
      Column(
        children: profile.workExperience!
            .map(
              (exp) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exp.jobTitle ?? 'Unknown Position',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (exp.company != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          exp.company!,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                      if (exp.startDate != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _formatEmploymentDate(
                            exp.startDate!,
                            exp.endDate,
                            exp.isCurrentJob ?? false,
                          ),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                      if (exp.description != null) ...[
                        const SizedBox(height: 8),
                        Text(exp.description!),
                      ],
                      if (exp.achievements != null &&
                          exp.achievements!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ...exp.achievements!.map(
                          (achievement) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• '),
                                Expanded(child: Text(achievement)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildEducation(BuildContext context, UserProfile profile) {
    if (profile.education == null || profile.education!.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildSection(
      context,
      'Education',
      Icons.school,
      Column(
        children: profile.education!
            .map(
              (edu) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(edu.degree ?? 'Unknown Degree'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (edu.institution != null) Text(edu.institution!),
                      if (edu.gpa != null) Text('GPA: ${edu.gpa}'),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSkills(BuildContext context, UserProfile profile) {
    if (profile.skills == null || profile.skills!.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildSection(
      context,
      'Skills',
      Icons.psychology,
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: profile.skills!
            .map(
              (skill) => Chip(
                label: Text(skill),
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.secondaryContainer,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildProjects(BuildContext context, UserProfile profile) {
    if (profile.projects == null || profile.projects!.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildSection(
      context,
      'Projects',
      Icons.code,
      Column(
        children: profile.projects!
            .map(
              (project) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(project.name ?? 'Unnamed Project'),
                  subtitle: project.description != null
                      ? Text(project.description!)
                      : null,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildCertifications(BuildContext context, UserProfile profile) {
    if (profile.certifications == null || profile.certifications!.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildSection(
      context,
      'Certifications',
      Icons.verified,
      Column(
        children: profile.certifications!
            .map(
              (cert) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.verified),
                  title: Text(cert),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    Widget content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatEmploymentDate(DateTime start, DateTime? end, bool isCurrent) {
    final startStr = '${start.month}/${start.year}';
    if (isCurrent) {
      return '$startStr - Present';
    } else if (end != null) {
      return '$startStr - ${end.month}/${end.year}';
    } else {
      return startStr;
    }
  }

  Future<void> _uploadResume(BuildContext context, WidgetRef ref) async {
    final documentService = ref.read(documentProcessingServiceProvider);
    final userProfileNotifier = ref.read(userProfileProvider.notifier);

    try {
      final profile = await documentService.pickAndProcessResume();
      if (profile != null) {
        userProfileNotifier.setProfile(profile);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Resume uploaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading resume: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _loadSampleData(WidgetRef ref) {
    final userProfileNotifier = ref.read(userProfileProvider.notifier);
    final sampleProfile = SampleResumeData.getSampleProfile();
    userProfileNotifier.setProfile(sampleProfile);
  }

  void _editProfile(BuildContext context, WidgetRef ref) {
    // TODO: Implement profile editing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile editing coming soon!')),
    );
  }
}
