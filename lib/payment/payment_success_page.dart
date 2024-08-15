import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentSuccessPage extends StatelessWidget {
  static const String route = '/payment_success';
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final double subtotal = args['subtotal'];
    final String paymentMethod = args['paymentMethod'];
    final String customerName = args['customerName'];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2B32B2),
              Color(0xFF1488CC),
            ]
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            size: 64,
                            color: Color(0xFF1A72DD),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Successful Transaction!',
                            style: GoogleFonts.rubik(
                              color: const Color(0xFF1A72DD),
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A72DD),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Orderer: $customerName',
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Divider(thickness: 0.5, color: Colors.white,),
                                Text(
                                  'Method Payment: $paymentMethod',
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Divider(thickness: 0.5, color: Colors.white,),
                                Text(
                                  'Total Price: Rp. $subtotal',
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/home'));},
                    child: Text(
                      'NEXT ORDER',
                      style: GoogleFonts.rubik(
                        color: const Color(0xFF1A72DD),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
