import 'package:flutter/material.dart';
import 'package:vet_reports_app/core/utils/helpers.dart';

class DateRangeDisplay extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const DateRangeDisplay({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Chip(
          label: Text(AppHelpers.formatDate(startDate)),
          backgroundColor: Colors.green.shade100,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('إلى'),
        ),
        Chip(
          label: Text(AppHelpers.formatDate(endDate)),
          backgroundColor: Colors.green.shade100,
        ),
      ],
    );
  }
}