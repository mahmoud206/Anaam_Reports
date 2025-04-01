import 'package:equatable/equatable.dart';
import 'dart:typed_data';

enum ReportType { payments, clinic, salesProfit, expenses, all }

class ReportsState extends Equatable {
  final Uint8List? pdfBytes;
  final DateTime? startDate;
  final DateTime? endDate;
  final ReportType? reportType;
  final String? errorMessage;
  final bool isLoading;
  final String? selectedDatabase;
  final bool isConnected;

  const ReportsState({
    this.pdfBytes,
    this.startDate,
    this.endDate,
    this.reportType,
    this.errorMessage,
    this.isLoading = false,
    this.selectedDatabase,
    this.isConnected = false,
  });

  factory ReportsState.initial() => const ReportsState();

  ReportsState copyWith({
    Uint8List? pdfBytes,
    DateTime? startDate,
    DateTime? endDate,
    ReportType? reportType,
    String? errorMessage,
    bool? isLoading,
    String? selectedDatabase,
    bool? isConnected,
  }) {
    return ReportsState(
      pdfBytes: pdfBytes ?? this.pdfBytes,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reportType: reportType ?? this.reportType,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
      selectedDatabase: selectedDatabase ?? this.selectedDatabase,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object?> get props => [
    pdfBytes,
    startDate,
    endDate,
    reportType,
    errorMessage,
    isLoading,
    selectedDatabase,
    isConnected,
  ];
}