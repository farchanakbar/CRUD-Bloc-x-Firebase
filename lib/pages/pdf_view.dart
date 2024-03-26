import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatelessWidget {
  const PdfView({required this.path, super.key});
  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SfPdfViewer.file(File(path)));
  }
}
