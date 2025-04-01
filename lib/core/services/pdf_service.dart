/*import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


Future<Uint8List> generateReport(List<Map<String, dynamic>> paymentsData, List<Map<String, dynamic>> servicesData) async {
  final pdf = pw.Document();
  final arabicFont = await PdfGoogleFonts.tajawalRegular();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            pw.SizedBox(height: 10),
            _buildTable(paymentsData, servicesData, arabicFont),
          ],
        );
      },
    ),
  );

  return pdf.save();
}

pw.Widget _buildHeader() {
  return pw.Container(
    alignment: pw.Alignment.center,
    padding: const pw.EdgeInsets.all(10),
    child: pw.Text(
      "تقرير مالي",
      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      textDirection: pw.TextDirection.rtl,
    ),
  );
}

pw.Widget _buildTable(List<Map<String, dynamic>> paymentsData, List<Map<String, dynamic>> servicesData, pw.Font arabicFont) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      _buildPaymentsSummary(paymentsData, arabicFont),
      pw.SizedBox(height: 20),
      _buildServicesSummary(servicesData, arabicFont),
    ],
  );
}

pw.Widget _buildPaymentsSummary(List<Map<String, dynamic>> paymentsData, pw.Font arabicFont) {
  final int totalPayments = paymentsData.fold<int>(0, (sum, item) => sum + (item['total'] as num? ?? 0).toInt());

  return pw.Container(
    padding: const pw.EdgeInsets.all(10),
    decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
    child: pw.Column(
      children: [
        pw.Text("ملخص المدفوعات", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 5),
        pw.Text("إجمالي المدفوعات: $totalPayments", style: const pw.TextStyle(fontSize: 12)),
      ],
    ),
  );
}

pw.Widget _buildServicesSummary(List<Map<String, dynamic>> servicesData, pw.Font arabicFont) {
  return pw.Table(
    border: pw.TableBorder.all(color: PdfColors.black),
    columnWidths: {
      0: const pw.FlexColumnWidth(2),
      1: const pw.FlexColumnWidth(1),
      2: const pw.FlexColumnWidth(1),
    },
    children: [
      pw.TableRow(
        children: [
          _buildHeaderCell("الخدمة", arabicFont),
          _buildHeaderCell("العدد", arabicFont),
          _buildHeaderCell("الإجمالي", arabicFont),
        ],
      ),
      ...servicesData.map((service) => pw.TableRow(
        children: [
          _buildDataCell(service['name'] ?? "غير معروف", arabicFont),
          _buildDataCell(service['count'] is num ? (service['count'] as num).toInt().toString() : "0", arabicFont),
          _buildDataCell(service['total'] is num ? (service['total'] as num).toInt().toString() : "0", arabicFont),
        ],
      )),
    ],
  );
}

pw.Widget _buildHeaderCell(String text, pw.Font arabicFont) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(8),
    decoration: pw.BoxDecoration(color: PdfColors.grey300, border: pw.Border.all(color: PdfColors.black)),
    child: pw.Text(text, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, font: arabicFont), textDirection: pw.TextDirection.rtl),
  );
}

pw.Widget _buildDataCell(dynamic value, pw.Font arabicFont) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(8),
    decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
    child: pw.Text(
      (value is num) ? value.toInt().toString() : value.toString(),
      style: pw.TextStyle(font: arabicFont, fontSize: 10),
      textDirection: pw.TextDirection.rtl,
    ),
  );
}*/
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart'; // Added for DateFormat
import 'package:vet_reports_app/features/reports/cubit/reports_state.dart'; // Added for ReportType

class PdfService {
  Future<Uint8List> generateReport(
      List<Map<String, dynamic>> primaryData,
      List<Map<String, dynamic>> secondaryData, {
        required ReportType reportType, // Made required
        required DateTime startDate,    // Made required
        required DateTime endDate,      // Made required
      }) async {
    final pdf = pw.Document();
    final arabicFont = await PdfGoogleFonts.tajawalRegular();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(reportType, startDate, endDate),
              pw.SizedBox(height: 10),
              _buildContent(primaryData, secondaryData, reportType, arabicFont),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(ReportType reportType, DateTime startDate, DateTime endDate) {
    final title = _getReportTitle(reportType);
    final dateRange = '${_formatDate(startDate)} - ${_formatDate(endDate)}';

    return pw.Container(
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        children: [
          pw.Text(
            title,
            style:  pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
            textDirection: pw.TextDirection.rtl,
          ),
          pw.Text(dateRange),
        ],
      ),
    );
  }

  String _getReportTitle(ReportType type) {
    switch (type) {
      case ReportType.payments:
        return 'تقرير المدفوعات';
      case ReportType.clinic:
        return 'تقرير العيادة';
      case ReportType.salesProfit:
        return 'تقرير المبيعات والأرباح';
      case ReportType.expenses:
        return 'تقرير المصروفات';
      case ReportType.all:
        return 'تقرير شامل';
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd', 'ar_SA').format(date);
  }

  pw.Widget _buildContent(
      List<Map<String, dynamic>> primaryData,
      List<Map<String, dynamic>> secondaryData,
      ReportType reportType,
      pw.Font arabicFont,
      ) {
    switch (reportType) {
      case ReportType.payments:
        return _buildPaymentsReport(primaryData, arabicFont);
      case ReportType.clinic:
        return _buildClinicReport(primaryData, arabicFont);
      case ReportType.salesProfit:
        return _buildSalesProfitReport(primaryData, arabicFont);
      case ReportType.expenses:
        return _buildExpensesReport(primaryData, arabicFont);
      case ReportType.all:
        return pw.Column(
          children: [
            _buildPaymentsReport(primaryData, arabicFont),
            pw.SizedBox(height: 20),
            _buildClinicReport(secondaryData, arabicFont),
          ],
        );
    }
  }

  pw.Widget _buildPaymentsReport(List<Map<String, dynamic>> data, pw.Font arabicFont) {
    final total = data.fold<double>(0, (sum, item) => sum + (item['total'] as num? ?? 0).toDouble());

    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: const {
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(1),
        2: pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          children: [
            _buildHeaderCell('طريقة الدفع', arabicFont),
            _buildHeaderCell('العدد', arabicFont),
            _buildHeaderCell('المبلغ', arabicFont),
          ],
        ),
        ...data.map((payment) => pw.TableRow(
          children: [
            _buildDataCell(payment['_id'] ?? 'غير معروف', arabicFont),
            _buildDataCell(payment['count'] ?? 0, arabicFont),
            _buildDataCell(payment['total'] ?? 0, arabicFont),
          ],
        )),
        pw.TableRow(
          children: [
            _buildHeaderCell('الإجمالي', arabicFont),
            _buildDataCell('', arabicFont),
            _buildDataCell(total, arabicFont),
          ],
        ),
      ],
    );
  }

  // Add similar methods for other report types
  pw.Widget _buildClinicReport(List<Map<String, dynamic>> data, pw.Font arabicFont) {
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: const {
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(1),
        2: pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          children: [
            _buildHeaderCell('الخدمة', arabicFont),
            _buildHeaderCell('العدد', arabicFont),
            _buildHeaderCell('الإيراد', arabicFont),
          ],
        ),
        ...data.map((service) => pw.TableRow(
          children: [
            _buildDataCell(service['_id'] ?? 'غير معروف', arabicFont),
            _buildDataCell(service['count'] ?? 0, arabicFont),
            _buildDataCell(service['totalRevenue'] ?? 0, arabicFont),
          ],
        )),
      ],
    );
  }

  pw.Widget _buildSalesProfitReport(List<Map<String, dynamic>> data, pw.Font arabicFont) {
    // Implement sales profit report layout
    return pw.Text('Sales Profit Report');
  }

  pw.Widget _buildExpensesReport(List<Map<String, dynamic>> data, pw.Font arabicFont) {
    // Implement expenses report layout
    return pw.Text('Expenses Report');
  }

  pw.Widget _buildHeaderCell(String text, pw.Font arabicFont) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: const pw.BoxDecoration(color: PdfColors.grey300),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          font: arabicFont,
        ),
        textDirection: pw.TextDirection.rtl,
      ),
    );
  }

  pw.Widget _buildDataCell(dynamic value, pw.Font arabicFont) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        _formatCellValue(value),
        style: pw.TextStyle(
          font: arabicFont,
          fontSize: 10,
        ),
        textDirection: pw.TextDirection.rtl,
      ),
    );
  }

  String _formatCellValue(dynamic value) {
    if (value == null) return '-';
    if (value is num) return value.toStringAsFixed(2);
    return value.toString();
  }
}