import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vet_reports_app/core/services/mongo_service.dart';
import 'package:vet_reports_app/core/services/pdf_service.dart';
import 'package:vet_reports_app/features/reports/cubit/reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final MongoService _mongoService;
  final PdfService _pdfService;
  bool _isGeneratingReport = false;

  ReportsCubit(this._mongoService, this._pdfService) : super(ReportsState.initial());

  Future<void> selectDatabase(String databaseName) async {
    if (_isGeneratingReport) return;

    try {
      emit(state.copyWith(
        isLoading: true,
        errorMessage: null,
        selectedDatabase: null,
      ));

      await _mongoService.disconnect(); // Ensure clean connection
      await _mongoService.connect(databaseName);

      emit(state.copyWith(
        isLoading: false,
        selectedDatabase: databaseName,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'فشل الاتصال بقاعدة البيانات: ${e.toString()}',
      ));
      rethrow;
    }
  }

  void setDateRange(DateTime startDate, DateTime endDate, ReportType reportType) {
    emit(state.copyWith(
      startDate: startDate,
      endDate: endDate,
      reportType: reportType,
      errorMessage: null,
    ));
  }

  Future<void> generateReports() async {
    if (_isGeneratingReport) return;
    _isGeneratingReport = true;

    if (state.startDate == null || state.endDate == null || state.reportType == null) {
      emit(state.copyWith(
        errorMessage: 'الرجاء تحديد نطاق التاريخ ونوع التقرير أولاً',
      ));
      _isGeneratingReport = false;
      return;
    }

    if (!_mongoService.isConnected) {
      emit(state.copyWith(
        errorMessage: 'غير متصل بقاعدة البيانات. الرجاء تحديد قاعدة بيانات أولاً',
      ));
      _isGeneratingReport = false;
      return;
    }

    try {
      emit(state.copyWith(
        isLoading: true,
        errorMessage: null,
        pdfBytes: null,
      ));

      late final List<Map<String, dynamic>> reportData;
      late final List<Map<String, dynamic>>? secondaryData;

      switch (state.reportType!) {
        case ReportType.payments:
          reportData = await _mongoService.getPaymentsReport(
            state.startDate!,
            state.endDate!,
          );
          secondaryData = null;
          break;
        case ReportType.clinic:
          reportData = await _mongoService.getClinicReport(
            state.startDate!,
            state.endDate!,
          );
          secondaryData = null;
          break;
        case ReportType.salesProfit:
          reportData = await _mongoService.getSalesProfitReport(
            state.startDate!,
            state.endDate!,
          );
          secondaryData = null;
          break;
        case ReportType.expenses:
          reportData = await _mongoService.getExpensesReport(
            state.startDate!,
            state.endDate!,
          );
          secondaryData = null;
          break;
        case ReportType.all:
          final payments = await _mongoService.getPaymentsReport(
            state.startDate!,
            state.endDate!,
          );
          final clinic = await _mongoService.getClinicReport(
            state.startDate!,
            state.endDate!,
          );
          reportData = payments;
          secondaryData = clinic;
          break;
      }

      if (reportData.isEmpty) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'لا توجد بيانات متاحة لهذا النطاق الزمني',
        ));
        _isGeneratingReport = false;
        return;
      }

      final pdfBytes = await _pdfService.generateReport(
        reportData,
        secondaryData ?? [],
        reportType: state.reportType!,
        startDate: state.startDate!,
        endDate: state.endDate!,
      );

      emit(state.copyWith(
        pdfBytes: pdfBytes,
        isLoading: false,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'فشل إنشاء التقرير: ${e.toString()}',
      ));
    } finally {
      _isGeneratingReport = false;
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  void clearReport() {
    emit(state.copyWith(pdfBytes: null));
  }

}