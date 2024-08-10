part of 'cart_bloc.dart';

class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {
  const CartLoading();

  @override
  List<Object> get props => [];
}

class CartLoaded extends CartState {
  final List<Cart> items;

  const CartLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class CartError extends CartState {
  final String error;

  const CartError(this.error);

  @override
  List<Object> get props => [error];
}
