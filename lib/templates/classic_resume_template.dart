import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:ui';
import '../models/user_profile.dart';

class ClassicResumeTemplate {
  static void build(PdfDocument document, UserProfile profile) {
    final page = document.pages.add();
    final graphics = page.graphics;
    final fontHeader = PdfStandardFont(
      PdfFontFamily.helvetica,
      18,
      style: PdfFontStyle.bold,
    );
    final fontTitle = PdfStandardFont(
      PdfFontFamily.helvetica,
      14,
      style: PdfFontStyle.bold,
    );
    final fontNormal = PdfStandardFont(PdfFontFamily.helvetica, 11);
    double y = 20;
    const double left = 20;
    final double width = page.getClientSize().width;

    // Name
    if (profile.name != null) {
      graphics.drawString(
        profile.name!,
        fontHeader,
        bounds: Rect.fromLTWH(left, y, width - left * 2, 30),
      );
      y += fontHeader.height + 10;
    }
    // Contact info
    String contact = '';
    if (profile.email != null) contact += profile.email!;
    if (profile.phone != null) contact += ' | ' + profile.phone!;
    if (profile.location != null) contact += ' | ' + profile.location!;
    if (contact.isNotEmpty) {
      graphics.drawString(
        contact,
        fontNormal,
        bounds: Rect.fromLTWH(left, y, width - left * 2, 20),
      );
      y += fontNormal.height + 10;
    }
    // Summary
    if (profile.professionalSummary != null) {
      graphics.drawString(
        'Professional Summary',
        fontTitle,
        bounds: Rect.fromLTWH(left, y, width - left * 2, 20),
      );
      y += fontTitle.height + 5;
      graphics.drawString(
        profile.professionalSummary!,
        fontNormal,
        bounds: Rect.fromLTWH(left, y, width - left * 2, 40),
      );
      y += fontNormal.height + 15;
    }
    // Work Experience
    if (profile.workExperience != null && profile.workExperience!.isNotEmpty) {
      graphics.drawString(
        'Work Experience',
        fontTitle,
        bounds: Rect.fromLTWH(left, y, width - left * 2, 20),
      );
      y += fontTitle.height + 5;
      for (var exp in profile.workExperience!) {
        String job = '';
        if (exp.jobTitle != null) job += exp.jobTitle!;
        if (exp.company != null) job += ' at ' + exp.company!;
        graphics.drawString(
          job,
          fontNormal,
          bounds: Rect.fromLTWH(left + 10, y, width - left * 2 - 10, 20),
        );
        y += fontNormal.height + 2;
        if (exp.description != null) {
          graphics.drawString(
            exp.description!,
            fontNormal,
            bounds: Rect.fromLTWH(left + 20, y, width - left * 2 - 20, 30),
          );
          y += fontNormal.height + 5;
        }
        y += 5;
      }
      y += 10;
    }
    // Education
    if (profile.education != null && profile.education!.isNotEmpty) {
      graphics.drawString(
        'Education',
        fontTitle,
        bounds: Rect.fromLTWH(left, y, width - left * 2, 20),
      );
      y += fontTitle.height + 5;
      for (var edu in profile.education!) {
        String eduStr = '';
        if (edu.degree != null) eduStr += edu.degree!;
        if (edu.institution != null) eduStr += ' - ' + edu.institution!;
        graphics.drawString(
          eduStr,
          fontNormal,
          bounds: Rect.fromLTWH(left + 10, y, width - left * 2 - 10, 20),
        );
        y += fontNormal.height + 2;
      }
      y += 10;
    }
    // Skills
    if (profile.skills != null && profile.skills!.isNotEmpty) {
      graphics.drawString(
        'Skills',
        fontTitle,
        bounds: Rect.fromLTWH(left, y, width - left * 2, 20),
      );
      y += fontTitle.height + 5;
      graphics.drawString(
        profile.skills!.join(', '),
        fontNormal,
        bounds: Rect.fromLTWH(left + 10, y, width - left * 2 - 10, 20),
      );
      y += fontNormal.height + 10;
    }
  }
}
