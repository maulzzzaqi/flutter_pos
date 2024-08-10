part of 'cart_bloc.dart';

class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddToCartEvent extends CartEvent {
  final Cart item;

  const AddToCartEvent(this.item);

  @override
  List<Object> get props => [item];
}

class LoadCartEvent extends CartEvent {
  const LoadCartEvent();

  @override
  List<Object> get props => [];
}
