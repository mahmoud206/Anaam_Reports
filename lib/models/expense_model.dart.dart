import 'package:realm/realm.dart';

class Expense {
  final ObjectId id;
  final double amount;
  final DateTime createdAt;
  final String employeeName;
  final bool isManagerial;
  final String note;
  final String type;

  Expense({
    required this.id,
    required this.amount,
    required this.createdAt,
    required this.employeeName,
    required this.isManagerial,
    required this.note,
    required this.type,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['_id'],
      amount: json['amount'].toDouble(),
      createdAt: json['createdAt'],
      employeeName: json['employeeName'],
      isManagerial: json['isManagerial'],
      note: json['note'],
      type: json['type'],
    );
  }
}