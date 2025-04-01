import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/strings.dart';
import '../../../features/shared/widgets/app_button.dart';
import '../../../features/shared/widgets/pdf_viewer.dart';
import '../cubit/reports_cubit.dart';
import '../cubit/reports_state.dart';

class ReportResultsScreen extends StatelessWidget {
  const ReportResultsScreen({super.key});

  String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd', 'ar_SA').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.reportGenerated),
        centerTitle: true,
      ),
      body: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          // Check for successful report generation
          if (state.pdfBytes != null && state.startDate != null && state.endDate != null) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/animations/success.json',
                    width: 200,
                    height: 200,
                    repeat: false,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'تم إنشاء التقرير بنجاح',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_formatDate(state.startDate!)} - ${_formatDate(state.endDate!)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    _getReportTypeName(state.reportType),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  AppButton(
                    text: AppStrings.viewReport,
                    icon: Icons.picture_as_pdf,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfViewerWidget(
                            pdfBytes: state.pdfBytes!,
                            title: _getReportTitle(state.reportType),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: AppStrings.shareReport,
                    icon: Icons.share,
                    onPressed: () => _shareReport(context, state),
                    backgroundColor: Colors.blue,
                  ),
                ],
              ),
            );
          }

          // Show loading or error states
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(
              child: Text(
                state.errorMessage!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.red,
                ),
              ),
            );
          }

          return const Center(child: Text('No report data available'));
        },
      ),
    );
  }

  String _getReportTypeName(ReportType? type) {
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
      default:
        return 'تقرير';
    }
  }

  String _getReportTitle(ReportType? type) {
    return _getReportTypeName(type);
  }

  Future<void> _shareReport(BuildContext context, ReportsState state) async {
    // TODO: Implement actual sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم تنفيذ المشاركة هنا'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}