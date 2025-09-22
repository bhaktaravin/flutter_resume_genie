// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      phone: fields[3] as String?,
      location: fields[4] as String?,
      professionalSummary: fields[5] as String?,
      workExperience: (fields[6] as List?)?.cast<WorkExperience>(),
      education: (fields[7] as List?)?.cast<Education>(),
      skills: (fields[8] as List?)?.cast<String>(),
      certifications: (fields[9] as List?)?.cast<String>(),
      projects: (fields[10] as List?)?.cast<Project>(),
      linkedinUrl: fields[11] as String?,
      githubUrl: fields[12] as String?,
      portfolioUrl: fields[13] as String?,
      lastUpdated: fields[14] as DateTime?,
      profileImagePath: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.professionalSummary)
      ..writeByte(6)
      ..write(obj.workExperience)
      ..writeByte(7)
      ..write(obj.education)
      ..writeByte(8)
      ..write(obj.skills)
      ..writeByte(9)
      ..write(obj.certifications)
      ..writeByte(10)
      ..write(obj.projects)
      ..writeByte(11)
      ..write(obj.linkedinUrl)
      ..writeByte(12)
      ..write(obj.githubUrl)
      ..writeByte(13)
      ..write(obj.portfolioUrl)
      ..writeByte(14)
      ..write(obj.lastUpdated)
      ..writeByte(15)
      ..write(obj.profileImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkExperienceAdapter extends TypeAdapter<WorkExperience> {
  @override
  final int typeId = 1;

  @override
  WorkExperience read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkExperience(
      jobTitle: fields[0] as String?,
      company: fields[1] as String?,
      location: fields[2] as String?,
      startDate: fields[3] as DateTime?,
      endDate: fields[4] as DateTime?,
      isCurrentJob: fields[5] as bool?,
      description: fields[6] as String?,
      achievements: (fields[7] as List?)?.cast<String>(),
      technologies: (fields[8] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkExperience obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.jobTitle)
      ..writeByte(1)
      ..write(obj.company)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.isCurrentJob)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.achievements)
      ..writeByte(8)
      ..write(obj.technologies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkExperienceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EducationAdapter extends TypeAdapter<Education> {
  @override
  final int typeId = 2;

  @override
  Education read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Education(
      degree: fields[0] as String?,
      institution: fields[1] as String?,
      location: fields[2] as String?,
      startDate: fields[3] as DateTime?,
      endDate: fields[4] as DateTime?,
      gpa: fields[5] as String?,
      description: fields[6] as String?,
      relevantCourses: (fields[7] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Education obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.degree)
      ..writeByte(1)
      ..write(obj.institution)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.gpa)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.relevantCourses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EducationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 3;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      name: fields[0] as String?,
      description: fields[1] as String?,
      technologies: (fields[2] as List?)?.cast<String>(),
      githubUrl: fields[3] as String?,
      liveUrl: fields[4] as String?,
      startDate: fields[5] as DateTime?,
      endDate: fields[6] as DateTime?,
      achievements: (fields[7] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.technologies)
      ..writeByte(3)
      ..write(obj.githubUrl)
      ..writeByte(4)
      ..write(obj.liveUrl)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.endDate)
      ..writeByte(7)
      ..write(obj.achievements);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
