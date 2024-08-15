import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String customerName;
  final List<Map<String, dynamic>> menuItems;
  final double subtotal;
  final String paymentMethod;
  final DateTime timestamp;

  TransactionModel({
    required this.id,
    required this.customerName,
    required this.menuItems,
    required this.subtotal,
    required this.paymentMethod,
    required this.timestamp,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      customerName: data['customerName'],
      menuItems: List<Map<String, dynamic>>.from(data['menuItems']),
      subtotal: data['subtotal'],
      paymentMethod: data['paymentMethod'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'menuItems': menuItems,
      'subtotal': subtotal,
      'paymentMethod': paymentMethod,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
