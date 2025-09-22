import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../models/user_profile.dart';
import 'groq_service.dart';

class DocumentProcessingService {
  final GroqService _groqService = GroqService();

  // Pick and process resume file
  Future<UserProfile?> pickAndProcessResume() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        String extractedText;
        if (file.extension?.toLowerCase() == 'pdf') {
          extractedText = await _extractTextFromPDF(file);
        } else {
          // For demo purposes, treat other files as text
          // In production, you'd want proper doc/docx parsing
          extractedText = await _extractTextFromFile(file);
        }

        if (extractedText.isNotEmpty) {
          return await _groqService.parseResumeText(extractedText);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to process resume: $e');
    }
  }

  // Extract text from PDF using Syncfusion
  Future<String> _extractTextFromPDF(PlatformFile file) async {
    try {
      Uint8List bytes;

      if (file.bytes != null) {
        bytes = file.bytes!;
      } else if (file.path != null) {
        bytes = await File(file.path!).readAsBytes();
      } else {
        throw Exception('Unable to read file');
      }

      // Load the PDF document
      PdfDocument document = PdfDocument(inputBytes: bytes);

      // Extract text from the entire document
      String extractedText = PdfTextExtractor(document).extractText();
      document.dispose();
      return extractedText.trim();
    } catch (e) {
      throw Exception('Failed to extract text from PDF: $e');
    }
  }

  // Extract text from other file types (placeholder implementation)
  Future<String> _extractTextFromFile(PlatformFile file) async {
    try {
      if (file.bytes != null) {
        return String.fromCharCodes(file.bytes!);
      } else if (file.path != null) {
        return await File(file.path!).readAsString();
      } else {
        throw Exception('Unable to read file');
      }
    } catch (e) {
      throw Exception('Failed to extract text from file: $e');
    }
  }

  // Generate PDF resume from user profile
  Future<Uint8List> generateResumePDF(
    UserProfile userProfile, {
    String? templateStyle,
  }) async {
    try {
      // Create a new PDF document
      PdfDocument document = PdfDocument();

      // Add a page to the document
      PdfPage page = document.pages.add();

      // Get the graphics of the page
      PdfGraphics graphics = page.graphics;

      // Set fonts
      PdfFont headerFont = PdfStandardFont(
        PdfFontFamily.helvetica,
        18,
        style: PdfFontStyle.bold,
      );
      PdfFont titleFont = PdfStandardFont(
        PdfFontFamily.helvetica,
        14,
        style: PdfFontStyle.bold,
      );
      PdfFont normalFont = PdfStandardFont(PdfFontFamily.helvetica, 11);
      PdfFont smallFont = PdfStandardFont(PdfFontFamily.helvetica, 10);

      double yPosition = 20;
      const double leftMargin = 20;
      const double rightMargin = 20;
      final double pageWidth = page.getClientSize().width;

      // Helper function to add text
      void addText(String text, PdfFont font, {double? x, double indent = 0}) {
        graphics.drawString(
          text,
          font,
          bounds: Rect.fromLTWH(
            (x ?? leftMargin) + indent,
            yPosition,
            pageWidth - leftMargin - rightMargin - indent,
            100,
          ),
        );
        yPosition += font.height + 5;
      }

      // Add header with name
      if (userProfile.name != null) {
        addText(userProfile.name!, headerFont);
        yPosition += 10;
      }

      // Add contact info
      String contactInfo = '';
      if (userProfile.email != null) contactInfo += userProfile.email!;
      if (userProfile.phone != null) {
        if (contactInfo.isNotEmpty) contactInfo += ' | ';
        contactInfo += userProfile.phone!;
      }
      if (userProfile.location != null) {
        if (contactInfo.isNotEmpty) contactInfo += ' | ';
        contactInfo += userProfile.location!;
      }

      if (contactInfo.isNotEmpty) {
        addText(contactInfo, normalFont);
        yPosition += 10;
      }

      // Add professional summary
      if (userProfile.professionalSummary != null) {
        addText('PROFESSIONAL SUMMARY', titleFont);
        addText(userProfile.professionalSummary!, normalFont);
        yPosition += 10;
      }

      // Add work experience
      if (userProfile.workExperience != null &&
          userProfile.workExperience!.isNotEmpty) {
        addText('WORK EXPERIENCE', titleFont);

        for (WorkExperience exp in userProfile.workExperience!) {
          String jobHeader = '';
          if (exp.jobTitle != null) jobHeader += exp.jobTitle!;
          if (exp.company != null) {
            if (jobHeader.isNotEmpty) jobHeader += ' at ';
            jobHeader += exp.company!;
          }

          if (jobHeader.isNotEmpty) {
            addText(jobHeader, normalFont);
          }

          String dates = '';
          if (exp.startDate != null) {
            dates += '${exp.startDate!.year}/${exp.startDate!.month}';
            if (exp.endDate != null) {
              dates += ' - ${exp.endDate!.year}/${exp.endDate!.month}';
            } else if (exp.isCurrentJob == true) {
              dates += ' - Present';
            }
          }

          if (dates.isNotEmpty) {
            addText(dates, smallFont);
          }

          if (exp.description != null) {
            addText(exp.description!, normalFont, indent: 10);
          }

          if (exp.achievements != null && exp.achievements!.isNotEmpty) {
            for (String achievement in exp.achievements!) {
              addText('• $achievement', normalFont, indent: 10);
            }
          }

          yPosition += 5;
        }
        yPosition += 10;
      }

      // Add education
      if (userProfile.education != null && userProfile.education!.isNotEmpty) {
        addText('EDUCATION', titleFont);

        for (Education edu in userProfile.education!) {
          String eduHeader = '';
          if (edu.degree != null) eduHeader += edu.degree!;
          if (edu.institution != null) {
            if (eduHeader.isNotEmpty) eduHeader += ' - ';
            eduHeader += edu.institution!;
          }

          if (eduHeader.isNotEmpty) {
            addText(eduHeader, normalFont);
          }

          if (edu.gpa != null) {
            addText('GPA: ${edu.gpa}', smallFont, indent: 10);
          }

          yPosition += 5;
        }
        yPosition += 10;
      }

      // Add skills
      if (userProfile.skills != null && userProfile.skills!.isNotEmpty) {
        addText('SKILLS', titleFont);
        addText(userProfile.skills!.join(', '), normalFont);
        yPosition += 10;
      }

      // Add projects
      if (userProfile.projects != null && userProfile.projects!.isNotEmpty) {
        addText('PROJECTS', titleFont);

        for (Project project in userProfile.projects!) {
          if (project.name != null) {
            addText(project.name!, normalFont);
          }

          if (project.description != null) {
            addText(project.description!, normalFont, indent: 10);
          }

          if (project.technologies != null &&
              project.technologies!.isNotEmpty) {
            addText(
              'Technologies: ${project.technologies!.join(', ')}',
              smallFont,
              indent: 10,
            );
          }

          yPosition += 5;
        }
      }

      // Save the document as bytes
      List<int> bytes = await document.save();
      document.dispose();

      return Uint8List.fromList(bytes);
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }

  void dispose() {
    // Groq service doesn't need disposal
  }
}

// Sample resume text for demo purposes
class SampleResumeData {
  static const String sampleResumeText = '''
John Smith
Senior Software Engineer
Email: john.smith@email.com
Phone: (555) 123-4567
Location: San Francisco, CA
LinkedIn: linkedin.com/in/johnsmith

PROFESSIONAL SUMMARY
Experienced software engineer with 8+ years developing scalable web applications and mobile apps. Expertise in full-stack development, cloud architecture, and AI/ML integration. Proven track record of leading teams and delivering high-impact products.

WORK EXPERIENCE

Senior Software Engineer - TechCorp Inc.
San Francisco, CA | Jan 2020 - Present
• Led development of microservices architecture serving 1M+ users
• Built AI-powered recommendation system increasing user engagement by 40%
• Mentored team of 5 junior developers and conducted code reviews
• Technologies: React, Node.js, Python, AWS, Docker, Kubernetes

Software Engineer - StartupXYZ
San Francisco, CA | Jun 2018 - Dec 2019
• Developed mobile app with React Native reaching 100K+ downloads
• Implemented CI/CD pipelines reducing deployment time by 60%
• Built real-time chat feature using WebSocket and Redis
• Technologies: React Native, Express.js, MongoDB, AWS

Junior Developer - WebSolutions LLC
San Jose, CA | Aug 2016 - May 2018
• Developed responsive websites for 20+ clients
• Collaborated with design team to implement pixel-perfect UIs
• Optimized database queries improving page load times by 30%
• Technologies: JavaScript, PHP, MySQL, WordPress

EDUCATION

Bachelor of Science in Computer Science
Stanford University | 2012 - 2016
GPA: 3.8/4.0
Relevant Coursework: Data Structures, Algorithms, Machine Learning, Database Systems

SKILLS
Programming Languages: JavaScript, Python, Java, TypeScript, Swift
Frontend: React, Vue.js, Angular, React Native, HTML5, CSS3
Backend: Node.js, Express, Django, Flask, Spring Boot
Databases: PostgreSQL, MongoDB, Redis, MySQL
Cloud & DevOps: AWS, Docker, Kubernetes, Jenkins, Git
AI/ML: TensorFlow, PyTorch, scikit-learn, OpenAI APIs

PROJECTS

AI Resume Parser
• Built intelligent resume parsing system using NLP and machine learning
• Extracts structured data from unstructured resume text with 95% accuracy
• Technologies: Python, spaCy, TensorFlow, FastAPI

E-commerce Platform
• Developed full-stack e-commerce solution with real-time inventory management
• Implemented secure payment processing and order tracking
• Technologies: React, Node.js, PostgreSQL, Stripe API

CERTIFICATIONS
• AWS Certified Solutions Architect - Professional
• Google Cloud Professional Developer
• Certified Scrum Master (CSM)
''';

  static UserProfile getSampleProfile() {
    return UserProfile(
      id: '1',
      name: 'John Smith',
      email: 'john.smith@email.com',
      phone: '(555) 123-4567',
      location: 'San Francisco, CA',
      professionalSummary:
          'Experienced software engineer with 8+ years developing scalable web applications and mobile apps. Expertise in full-stack development, cloud architecture, and AI/ML integration.',
      workExperience: [
        WorkExperience(
          jobTitle: 'Senior Software Engineer',
          company: 'TechCorp Inc.',
          location: 'San Francisco, CA',
          startDate: DateTime(2020, 1),
          isCurrentJob: true,
          description:
              'Led development of microservices architecture serving 1M+ users',
          achievements: [
            'Built AI-powered recommendation system increasing user engagement by 40%',
            'Mentored team of 5 junior developers and conducted code reviews',
          ],
          technologies: [
            'React',
            'Node.js',
            'Python',
            'AWS',
            'Docker',
            'Kubernetes',
          ],
        ),
        WorkExperience(
          jobTitle: 'Software Engineer',
          company: 'StartupXYZ',
          location: 'San Francisco, CA',
          startDate: DateTime(2018, 6),
          endDate: DateTime(2019, 12),
          isCurrentJob: false,
          description:
              'Developed mobile app with React Native reaching 100K+ downloads',
          achievements: [
            'Implemented CI/CD pipelines reducing deployment time by 60%',
            'Built real-time chat feature using WebSocket and Redis',
          ],
          technologies: ['React Native', 'Express.js', 'MongoDB', 'AWS'],
        ),
      ],
      education: [
        Education(
          degree: 'Bachelor of Science in Computer Science',
          institution: 'Stanford University',
          location: 'Stanford, CA',
          startDate: DateTime(2012, 9),
          endDate: DateTime(2016, 6),
          gpa: '3.8/4.0',
          relevantCourses: [
            'Data Structures',
            'Algorithms',
            'Machine Learning',
            'Database Systems',
          ],
        ),
      ],
      skills: [
        'JavaScript',
        'Python',
        'React',
        'Node.js',
        'AWS',
        'Docker',
        'Machine Learning',
        'TensorFlow',
        'PostgreSQL',
        'MongoDB',
        'React Native',
        'TypeScript',
      ],
      certifications: [
        'AWS Certified Solutions Architect - Professional',
        'Google Cloud Professional Developer',
        'Certified Scrum Master (CSM)',
      ],
      projects: [
        Project(
          name: 'AI Resume Parser',
          description:
              'Built intelligent resume parsing system using NLP and machine learning',
          technologies: ['Python', 'spaCy', 'TensorFlow', 'FastAPI'],
          githubUrl: 'https://github.com/johnsmith/ai-resume-parser',
        ),
        Project(
          name: 'E-commerce Platform',
          description:
              'Developed full-stack e-commerce solution with real-time inventory management',
          technologies: ['React', 'Node.js', 'PostgreSQL', 'Stripe API'],
          liveUrl: 'https://ecommerce-demo.com',
        ),
      ],
      linkedinUrl: 'https://linkedin.com/in/johnsmith',
      githubUrl: 'https://github.com/johnsmith',
      lastUpdated: DateTime.now(),
    );
  }
}
