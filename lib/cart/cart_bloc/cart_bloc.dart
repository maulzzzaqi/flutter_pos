import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_pos/cart/model/cart.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoaded([])) {
    on<CartEvent>((event, emit) {
      on<AddToCartEvent>((event, emit) {
        final currentState = state;
        if (currentState is CartLoaded) {
          final cart = List<Cart>.from(currentState.items);
          final index = cart.indexWhere((item) => item.id == event.item.id);

          if (index != -1) {
            cart[index] = Cart(
              id: cart[index].id,
              name: cart[index].name,
              price: cart[index].price,
              quantity: cart[index].quantity + 1,
            );
          } else {
            cart.add(event.item);
          }

          emit(CartLoaded(cart));
        } else {
          emit(CartLoaded([event.item]));
        }
      });
      on<RemoveCartEvent>((event, emit) {
        final currentState = state;
        if (currentState is CartLoaded) {
          final cart = List<Cart>.from(currentState.items)
            ..removeWhere((item) => item.id == event.item.id);
          emit(CartLoaded(cart));
        }
      });
    });
  }
}
