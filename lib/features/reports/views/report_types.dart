import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:vet_reports_app/core/constants/strings.dart';
import 'package:vet_reports_app/features/reports/cubit/reports_cubit.dart';
import 'package:vet_reports_app/features/reports/cubit/reports_state.dart';

class ReportTypesScreen extends StatelessWidget {
  const ReportTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.selectReportType),
        centerTitle: true,
      ),
      body: BlocListener<ReportsCubit, ReportsState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
            context.read<ReportsCubit>().clearError();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Lottie.asset(
                'assets/animations/report.json',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              Text(
                AppStrings.selectReportTypePrompt,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildReportTypeCard(
                      context,
                      icon: Icons.payment,
                      title: AppStrings.paymentsReport,
                      onTap: () => _handleReportSelection(context, ReportType.payments),
                    ),
                    _buildReportTypeCard(
                      context,
                      icon: Icons.medical_services,
                      title: AppStrings.clinicReport,
                      onTap: () => _handleReportSelection(context, ReportType.clinic),
                    ),
                    _buildReportTypeCard(
                      context,
                      icon: Icons.shopping_cart,
                      title: AppStrings.salesProfitReport,
                      onTap: () => _handleReportSelection(context, ReportType.salesProfit),
                    ),
                    _buildReportTypeCard(
                      context,
                      icon: Icons.money_off,
                      title: AppStrings.expensesReport,
                      onTap: () => _handleReportSelection(context, ReportType.expenses),
                    ),
                    _buildReportTypeCard(
                      context,
                      icon: Icons.all_inbox,
                      title: AppStrings.allReports,
                      onTap: () => _handleReportSelection(context, ReportType.all),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportTypeCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleReportSelection(BuildContext context, ReportType reportType) async {
    final cubit = context.read<ReportsCubit>();
    final currentState = cubit.state;

    // Check if dates are selected
    if (currentState.startDate == null || currentState.endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date range first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Set the report type and generate report
    cubit.setDateRange(
      currentState.startDate!,
      currentState.endDate!,
      reportType,
    );

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await cubit.generateReports();
      if (context.mounted) {
        Navigator.pop(context); // Remove loading dialog
        Navigator.pushNamed(context, '/report_results');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Remove loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate report: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}