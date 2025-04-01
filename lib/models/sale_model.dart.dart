import 'package:realm/realm.dart';

class SaleItem {
  final double price;
  final int quantity;
  final String serviceName;
  final double tax;

  SaleItem({
    required this.price,
    required this.quantity,
    required this.serviceName,
    required this.tax,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      serviceName: json['serviceName'],
      tax: json['tax'].toDouble(),
    );
  }
}

class Sale {
  final ObjectId id;
  final String contactName;
  final DateTime createdAt;
  final double discount;
  final String employeeName;
  final bool isResolved;
  final List<SaleItem> items;
  final double netTotal;
  final String note;
  final ObjectId paymentId;
  final DateTime resolveAt;
  final double taxesSum;

  Sale({
    required this.id,
    required this.contactName,
    required this.createdAt,
    required this.discount,
    required this.employeeName,
    required this.isResolved,
    required this.items,
    required this.netTotal,
    required this.note,
    required this.paymentId,
    required this.resolveAt,
    required this.taxesSum,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['_id'],
      contactName: json['contactName'],
      createdAt: json['createdAt'],
      discount: json['discount'].toDouble(),
      employeeName: json['employeeName'],
      isResolved: json['isResolved'],
      items: List<SaleItem>.from(
          json['items'].map((item) => SaleItem.fromJson(item))),
      netTotal: json['netTotal'].toDouble(),
      note: json['note'],
      paymentId: json['paymentId'],
      resolveAt: json['resolveAt'],
      taxesSum: json['taxesSum'].toDouble(),
    );
  }
}