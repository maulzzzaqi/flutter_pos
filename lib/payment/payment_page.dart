import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentPage extends StatefulWidget {
  static const String route = '/payment';
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPaymentMethod = '';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final double subtotal = args['subtotal'];
    final String customerName = args['customerName'];
    final List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(args['items']);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: GoogleFonts.rubik(
            color: const Color(0xFF1A72DD),
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Colors.black,
                      width: 0.2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Total bill:',
                      style: GoogleFonts.rubik(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Rp. $subtotal',
                      style: GoogleFonts.rubik(
                        color: const Color(0xFF1A72DD),
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Payment Method:',
                      style: GoogleFonts.rubik(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    paymentMethodCard('E-Wallet/QRIS', [
                      'https://seeklogo.com/images/Q/quick-response-code-indonesia-standard-qris-logo-F300D5EB32-seeklogo.com.png',
                      'https://antinomi.org/wp-content/uploads/2022/03/logo-gopay-vector.png',
                      'https://antinomi.org/wp-content/uploads/2022/03/1200px-Logo_dana_blue.svg.png'
                    ]),
                    paymentMethodCard('Credit Card/Debit Card', [
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/1200px-Mastercard-logo.svg.png',
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Visa_Logo.png/640px-Visa_Logo.png',
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Gerbang_Pembayaran_Nasional_logo.svg/1615px-Gerbang_Pembayaran_Nasional_logo.svg.png',
                    ]),
                    paymentMethodCard('Cash', [], isCash: true),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A72DD),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                onPressed: selectedPaymentMethod.isNotEmpty 
                ? () {
                  _handleTransaction(
                    customerName,
                    items,
                    subtotal,
                    selectedPaymentMethod
                  );
                }
                : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Select your payment method first!'))
                  );
                },
                child: Text(
                  'Proceed Transaction',
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentMethodCard(String paymentMethod, List<String> paymentLogo, {bool isCash = false}) {
    bool isSelected = selectedPaymentMethod == paymentMethod;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = paymentMethod;
        });
      },
      child: Card(
        color: isSelected ? Colors.blue.shade300 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                paymentMethod,
                style: GoogleFonts.rubik(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: isCash 
                ? [
                  Container(
                    width: 100,
                    height: 50,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    child: const Icon(
                      Icons.money,
                      size: 50,
                    ),
                  ),
                ]
                : paymentLogo.map((logo) {
                    return Container(
                      width: 100,
                      height: 50,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      child: Image.network(logo),
                    );
                  }).toList(),
              )
            ],
          )
        ),
      ),
    );
  }

  void _handleTransaction(
    String customerName,
    List<Map<String, dynamic>> items,
    double subtotal,
    String paymentMethod,
  ) {
    final transaction = {
      'customerName': customerName,
      'items': items,
      'subtotal': subtotal,
      'paymentMethod': paymentMethod,
      'timestamp': Timestamp.now(),
    };
    
    FirebaseFirestore.instance.collection('transactions').add(transaction)
      .then((value) {
        Navigator.pushNamed(context, '/payment_success', arguments: {
          'subtotal': subtotal,
          'paymentMethod': paymentMethod,
          'customerName': customerName,
        });
      }).catchError((error) {
        print('Failed to add transaction: $error');
      });
  }
}
