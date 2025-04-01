/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:vet_reports_app/core/constants/strings.dart';
import 'package:vet_reports_app/core/utils/helpers.dart';
import 'package:vet_reports_app/features/shared/widgets/app_button.dart';
import 'package:vet_reports_app/features/reports/cubit/reports_cubit.dart';
import 'package:vet_reports_app/features/reports/cubit/reports_state.dart';

class DateRangePickerScreen extends StatefulWidget {
  final ReportType reportType;

  const DateRangePickerScreen({super.key, required this.reportType});

  @override
  State<DateRangePickerScreen> createState() => _DateRangePickerScreenState();
}

class _DateRangePickerScreenState extends State<DateRangePickerScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.selectDateRange),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Lottie.asset(
              'assets/animations/calendar.json',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            _buildDatePickerField(
              context,
              label: AppStrings.startDate,
              value: _startDate,
              onTap: () => _pickDate(context, isStartDate: true),
            ),
            const SizedBox(height: 20),
            _buildDatePickerField(
              context,
              label: AppStrings.endDate,
              value: _endDate,
              onTap: () => _pickDate(context, isStartDate: false),
            ),
            const Spacer(),
            AppButton(
              text: AppStrings.confirm,
              onPressed: () {
                context.read<ReportsCubit>().setDateRange(
                  _startDate!,
                  _endDate!,
                  widget.reportType, // Pass the reportType from widget
                );
                Navigator.pushNamed(context, '/report_types');
              },
              disabled: _startDate == null || _endDate == null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerField(
      BuildContext context, {
        required String label,
        required DateTime? value,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 16),
            Text(
              value != null ? AppHelpers.formatDate(value) : label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: value != null ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, {required bool isStartDate}) async {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2020, 1, 1),
      maxTime: DateTime.now(),
      locale: LocaleType.ar,
      onConfirm: (date) {
        setState(() {
          if (isStartDate) {
            _startDate = date;
            if (_endDate != null && _endDate!.isBefore(_startDate!)) {
              _endDate = null;
            }
          } else {
            _endDate = date;
          }
        });
      },
      currentTime: isStartDate ? _startDate : _endDate,
    );
  }
}*/


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vet_reports_app/core/constants/strings.dart';
import 'package:vet_reports_app/core/utils/helpers.dart';
import 'package:vet_reports_app/features/shared/widgets/app_button.dart';
import 'package:vet_reports_app/features/reports/cubit/reports_cubit.dart';
import 'package:vet_reports_app/features/reports/cubit/reports_state.dart';
class DateRangePickerScreen extends StatefulWidget {
  final ReportType reportType;

  const DateRangePickerScreen({super.key, required this.reportType});

  @override
  State<DateRangePickerScreen> createState() => _DateRangePickerScreenState();
}

class _DateRangePickerScreenState extends State<DateRangePickerScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.selectDateRange),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Lottie.asset(
              'assets/animations/calendar.json',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            _buildDatePickerField(
              context,
              label: AppStrings.startDate,
              value: _startDate,
              onTap: () => _showDatePicker(isStartDate: true),
            ),
            const SizedBox(height: 20),
            _buildDatePickerField(
              context,
              label: AppStrings.endDate,
              value: _endDate,
              onTap: () => _showDatePicker(isStartDate: false),
            ),
            const Spacer(),
            AppButton(
              text: AppStrings.confirm,
              onPressed: _handleConfirm,
              disabled: _startDate == null || _endDate == null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerField(
    BuildContext context, {
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 16),
            Text(
              value != null ? AppHelpers.formatDate(value) : label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: value != null ? Colors.black : Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker({required bool isStartDate}) async {
    final initialDate = isStartDate ? _startDate : _endDate;
    final firstDate = DateTime(2020);
    final lastDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl, // For Arabic support
        child: AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: SfDateRangePicker(
              initialSelectedDate: initialDate,
              minDate: firstDate,
              maxDate: lastDate,
              selectionMode: DateRangePickerSelectionMode.single,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                Navigator.pop(context);
                _handleDateSelection(args.value, isStartDate);
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handleDateSelection(dynamic value, bool isStartDate) {
    if (value is DateTime) {
      setState(() {
        if (isStartDate) {
          _startDate = value;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = value;
        }
      });
    }
  }

  void _handleConfirm() {
    if (_startDate != null && _endDate != null) {
      context.read<ReportsCubit>().setDateRange(
            _startDate!,
            _endDate!,
            widget.reportType,
          );
      Navigator.pushNamed(context, '/report_types');
    }
  }
}