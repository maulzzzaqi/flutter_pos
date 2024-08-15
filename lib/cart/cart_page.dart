import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/cart/cart_bloc/cart_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatefulWidget {
  static const String route = '/cart';
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController customerController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    customerController.addListener(() {
      setState(() {
        isButtonEnabled = customerController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: GoogleFonts.rubik(
            color: const Color(0xFF1A72DD),
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoaded) {
              final hasItems = state.items.isNotEmpty;
              final hasNoItems = state.items.isEmpty;

              final subtotal = state.items.fold<double>(
                0.0,
                (sum, item) => sum + item.price * item.quantity,
              );

              return Column(
                children: [
                  if (hasNoItems)
                    Text(
                      'No item has been added.\nPlease add a menu to order!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return ListTile(
                          title: Text(
                            item.name,
                            style: GoogleFonts.rubik(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                'Quantity: ${item.quantity}',
                                style: GoogleFonts.rubik(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Rp. ${item.price * item.quantity}',
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF1A72DD),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  context
                                      .read<CartBloc>()
                                      .add(DecreaseQuantityEvent(item));
                                },
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  context.read<CartBloc>().add(IncreaseQuantityEvent(item));
                                },
                              ),
                              IconButton(
                                onPressed: () {
                                  context.read<CartBloc>().add(RemoveCartEvent(item));
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        );
                      },
                    ),
                  ),
                  if (hasItems)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Price: ',
                              style: GoogleFonts.rubik(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Rp. $subtotal',
                              style: GoogleFonts.rubik(
                                color: const Color(0xFF1A72DD),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: customerController,
                          decoration: InputDecoration(
                            hintText: 'Customer Name',
                            hintStyle: GoogleFonts.rubik(
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A72DD),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            onPressed: isButtonEnabled ? () {
                              Navigator.pushNamed(context, '/payment');
                            }
                            : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter the customer name!'))
                              );
                            }, 
                            child: Text(
                              'Choose Payment Method',
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              );
            } else if (state is CartError) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
