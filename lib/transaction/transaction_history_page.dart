import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionHistoryPage extends StatefulWidget {
  static const String route = '/history';
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  List<Map<String, dynamic>> transactions = [];
  DateTime? startDate;
  DateTime? endDate;
  double? minPrice;
  double? maxPrice;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('timestamp', isGreaterThanOrEqualTo: startDate ?? DateTime(2000))
          .where('timestamp', isLessThanOrEqualTo: endDate ?? DateTime.now())
          .get();

      final fetchedTransactions = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      setState(() {
        transactions = fetchedTransactions.where((transaction) {
          final double price = transaction['subtotal']?.toDouble() ?? 0.0;
          return (minPrice == null || price >= minPrice!) &&
                 (maxPrice == null || price <= maxPrice!);
        }).toList();
      });
    } catch (e) {
      print('Failed to fetch transactions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaction History',
          style: GoogleFonts.rubik(
            color: const Color(0xFF1A72DD),
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: transactions.isEmpty
          ? const Center(child: Text('No transactions found.'))
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                final itemsOrdered = transaction['items'] as List<dynamic>? ?? [];

                print('Transaction: $transaction');
                print('Items Ordered: $itemsOrdered');

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ExpansionTile(
                    title: Text(transaction['customerName'] ?? 'Unknown'),
                    subtitle: Text(
                      'Subtotal: Rp. ${transaction['subtotal']} \nPayment Method: ${transaction['paymentMethod']}',
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Items Ordered:',
                              style: GoogleFonts.rubik(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (itemsOrdered.isEmpty)
                              const Text('No items ordered')
                            else
                              ...itemsOrdered.map((item) {
                                final itemName = item['name'] ?? 'Unknown Item';
                                final itemQuantity = item['quantity']?.toString() ?? '0';
                                final itemPrice = item['price']?.toString() ?? '0';

                                return ListTile(
                                  title: Text(itemName),
                                  subtitle: Text('Quantity: $itemQuantity, Price: Rp. $itemPrice'),
                                );
                              }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
