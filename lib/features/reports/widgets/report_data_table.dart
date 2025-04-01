import 'package:flutter/material.dart';
import 'package:vet_reports_app/core/utils/helpers.dart';

class ReportDataTable extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;
  final bool isCurrency;

  const ReportDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.isCurrency = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns.map((col) => DataColumn(label: Text(col))).toList(),
        rows: rows.map((row) {
          return DataRow(
            cells: row.map((cell) {
              return DataCell(Text(
                isCurrency && double.tryParse(cell) != null
                    ? AppHelpers.formatCurrency(double.parse(cell))
                    : cell,
              ));
            }).toList(),
          );
        }).toList(),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}