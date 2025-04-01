import 'package:flutter/material.dart';
import 'package:vet_reports_app/features/intro/intro_page.dart';
import 'package:vet_reports_app/features/reports/cubit/reports_state.dart';
import 'package:vet_reports_app/features/reports/views/database_selector.dart';
import 'package:vet_reports_app/features/reports/views/date_range_picker.dart';
import 'package:vet_reports_app/features/reports/views/report_results.dart';
import 'package:vet_reports_app/features/reports/views/report_types.dart';

class AppRoutes {
  static const String intro = '/';
  static const String databaseSelector = '/database_selector';
  static const String dateRangePicker = '/date_range';
  static const String reportTypes = '/report_types';
  static const String reportResults = '/report_results';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case intro:
        return MaterialPageRoute(builder: (_) => const IntroPage());
      case databaseSelector:
        return MaterialPageRoute(builder: (_) => const DatabaseSelectorScreen());
      case dateRangePicker:
      // Get reportType from arguments
        final args = settings.arguments as ReportType? ?? ReportType.clinic;
        return MaterialPageRoute(
          builder: (_) => DateRangePickerScreen(reportType: args),
        );
      case reportTypes:
        return MaterialPageRoute(builder: (_) => const ReportTypesScreen());
      case reportResults:
        return MaterialPageRoute(builder: (_) => const ReportResultsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
    }
  }
}