import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class PdfViewerWidget extends StatefulWidget {
  final Uint8List pdfBytes;
  final String title;

  const PdfViewerWidget({
    Key? key,
    required this.pdfBytes,
    required this.title,
  }) : super(key: key);

  @override
  _PdfViewerWidgetState createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  late PdfController _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfController(
      document: PdfDocument.openData(widget.pdfBytes),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _printPdf(context),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePdf(context),
          ),
        ],
      ),
      body: ValueListenableBuilder<PdfLoadingState>(
        valueListenable: _pdfController.loadingState,
        builder: (context, loadingState, child) {
          if (loadingState == PdfLoadingState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (loadingState == PdfLoadingState.error) {
            return const Center(child: Text('Failed to load PDF document.'));
          } else {
            return PdfView(
              controller: _pdfController,
              scrollDirection: Axis.vertical,
            );
          }
        },
      ),
    );
  }

  Future<void> _printPdf(BuildContext context) async {
    try {
      await Printing.layoutPdf(
        onLayout: (_) => widget.pdfBytes,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Print failed: ${e.toString()}')),
      );
    }
  }

  Future<void> _sharePdf(BuildContext context) async {
    try {
      final xFile = XFile.fromData(
        widget.pdfBytes,
        name: '${widget.title}.pdf',
        mimeType: 'application/pdf',
      );
      await Share.shareXFiles([xFile]);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Share failed: ${e.toString()}')),
      );
    }
  }
}
