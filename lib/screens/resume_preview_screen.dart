import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../models/user_profile.dart';
import '../templates/classic_resume_template.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ResumePreviewScreen extends StatefulWidget {
  final UserProfile userProfile;
  const ResumePreviewScreen({Key? key, required this.userProfile})
    : super(key: key);

  @override
  State<ResumePreviewScreen> createState() => _ResumePreviewScreenState();
}

class _ResumePreviewScreenState extends State<ResumePreviewScreen> {
  Uint8List? pdfBytes;

  @override
  void initState() {
    super.initState();
    _generatePdf();
  }

  Future<void> _generatePdf() async {
    final document = PdfDocument();
    ClassicResumeTemplate.build(document, widget.userProfile);
    final bytes = await document.save();
    document.dispose();
    setState(() {
      pdfBytes = Uint8List.fromList(bytes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resume Preview')),
      body: pdfBytes == null
          ? const Center(child: CircularProgressIndicator())
          : SfPdfViewer.memory(pdfBytes!),
    );
  }
}
