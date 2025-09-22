import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? phone;

  @HiveField(4)
  String? location;

  @HiveField(5)
  String? professionalSummary;

  @HiveField(6)
  List<WorkExperience>? workExperience;

  @HiveField(7)
  List<Education>? education;

  @HiveField(8)
  List<String>? skills;

  @HiveField(9)
  List<String>? certifications;

  @HiveField(10)
  List<Project>? projects;

  @HiveField(11)
  String? linkedinUrl;

  @HiveField(12)
  String? githubUrl;

  @HiveField(13)
  String? portfolioUrl;

  @HiveField(14)
  DateTime? lastUpdated;

  @HiveField(15)
  String? profileImagePath;

  UserProfile({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.location,
    this.professionalSummary,
    this.workExperience,
    this.education,
    this.skills,
    this.certifications,
    this.projects,
    this.linkedinUrl,
    this.githubUrl,
    this.portfolioUrl,
    this.lastUpdated,
    this.profileImagePath,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? professionalSummary,
    List<WorkExperience>? workExperience,
    List<Education>? education,
    List<String>? skills,
    List<String>? certifications,
    List<Project>? projects,
    String? linkedinUrl,
    String? githubUrl,
    String? portfolioUrl,
    DateTime? lastUpdated,
    String? profileImagePath,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      professionalSummary: professionalSummary ?? this.professionalSummary,
      workExperience: workExperience ?? this.workExperience,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      certifications: certifications ?? this.certifications,
      projects: projects ?? this.projects,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'professionalSummary': professionalSummary,
      'workExperience': workExperience?.map((e) => e.toJson()).toList(),
      'education': education?.map((e) => e.toJson()).toList(),
      'skills': skills,
      'certifications': certifications,
      'projects': projects?.map((e) => e.toJson()).toList(),
      'linkedinUrl': linkedinUrl,
      'githubUrl': githubUrl,
      'portfolioUrl': portfolioUrl,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'profileImagePath': profileImagePath,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      location: json['location'],
      professionalSummary: json['professionalSummary'],
      workExperience: json['workExperience'] != null
          ? (json['workExperience'] as List)
                .map((e) => WorkExperience.fromJson(e))
                .toList()
          : null,
      education: json['education'] != null
          ? (json['education'] as List)
                .map((e) => Education.fromJson(e))
                .toList()
          : null,
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      certifications: json['certifications'] != null
          ? List<String>.from(json['certifications'])
          : null,
      projects: json['projects'] != null
          ? (json['projects'] as List).map((e) => Project.fromJson(e)).toList()
          : null,
      linkedinUrl: json['linkedinUrl'],
      githubUrl: json['githubUrl'],
      portfolioUrl: json['portfolioUrl'],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
      profileImagePath: json['profileImagePath'],
    );
  }
}

@HiveType(typeId: 1)
class WorkExperience extends HiveObject {
  @HiveField(0)
  String? jobTitle;

  @HiveField(1)
  String? company;

  @HiveField(2)
  String? location;

  @HiveField(3)
  DateTime? startDate;

  @HiveField(4)
  DateTime? endDate;

  @HiveField(5)
  bool? isCurrentJob;

  @HiveField(6)
  String? description;

  @HiveField(7)
  List<String>? achievements;

  @HiveField(8)
  List<String>? technologies;

  WorkExperience({
    this.jobTitle,
    this.company,
    this.location,
    this.startDate,
    this.endDate,
    this.isCurrentJob,
    this.description,
    this.achievements,
    this.technologies,
  });

  Map<String, dynamic> toJson() {
    return {
      'jobTitle': jobTitle,
      'company': company,
      'location': location,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCurrentJob': isCurrentJob,
      'description': description,
      'achievements': achievements,
      'technologies': technologies,
    };
  }

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      jobTitle: json['jobTitle'],
      company: json['company'],
      location: json['location'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCurrentJob: json['isCurrentJob'],
      description: json['description'],
      achievements: json['achievements'] != null
          ? List<String>.from(json['achievements'])
          : null,
      technologies: json['technologies'] != null
          ? List<String>.from(json['technologies'])
          : null,
    );
  }
}

@HiveType(typeId: 2)
class Education extends HiveObject {
  @HiveField(0)
  String? degree;

  @HiveField(1)
  String? institution;

  @HiveField(2)
  String? location;

  @HiveField(3)
  DateTime? startDate;

  @HiveField(4)
  DateTime? endDate;

  @HiveField(5)
  String? gpa;

  @HiveField(6)
  String? description;

  @HiveField(7)
  List<String>? relevantCourses;

  Education({
    this.degree,
    this.institution,
    this.location,
    this.startDate,
    this.endDate,
    this.gpa,
    this.description,
    this.relevantCourses,
  });

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'institution': institution,
      'location': location,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'gpa': gpa,
      'description': description,
      'relevantCourses': relevantCourses,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      degree: json['degree'],
      institution: json['institution'],
      location: json['location'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      gpa: json['gpa'],
      description: json['description'],
      relevantCourses: json['relevantCourses'] != null
          ? List<String>.from(json['relevantCourses'])
          : null,
    );
  }
}

@HiveType(typeId: 3)
class Project extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? description;

  @HiveField(2)
  List<String>? technologies;

  @HiveField(3)
  String? githubUrl;

  @HiveField(4)
  String? liveUrl;

  @HiveField(5)
  DateTime? startDate;

  @HiveField(6)
  DateTime? endDate;

  @HiveField(7)
  List<String>? achievements;

  Project({
    this.name,
    this.description,
    this.technologies,
    this.githubUrl,
    this.liveUrl,
    this.startDate,
    this.endDate,
    this.achievements,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'technologies': technologies,
      'githubUrl': githubUrl,
      'liveUrl': liveUrl,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'achievements': achievements,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'],
      description: json['description'],
      technologies: json['technologies'] != null
          ? List<String>.from(json['technologies'])
          : null,
      githubUrl: json['githubUrl'],
      liveUrl: json['liveUrl'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      achievements: json['achievements'] != null
          ? List<String>.from(json['achievements'])
          : null,
    );
  }
}
