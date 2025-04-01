import 'package:realm/realm.dart';

class Payment {
  final ObjectId id;
  final double amount;
  final String contactName;
  final DateTime createdAt;
  final String employeeName;
  final bool isOutgoing;
  final String method;
  final String note;
  final DateTime paidAt;

  Payment({
    required this.id,
    required this.amount,
    required this.contactName,
    required this.createdAt,
    required this.employeeName,
    required this.isOutgoing,
    required this.method,
    required this.note,
    required this.paidAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['_id'],
      amount: json['amount'].toDouble(),
      contactName: json['contactName'],
      createdAt: json['createdAt'],
      employeeName: json['employeeName'],
      isOutgoing: json['isOutgoing'],
      method: json['method'],
      note: json['note'],
      paidAt: json['paidAt'],
    );
  }
}