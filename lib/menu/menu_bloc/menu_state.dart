part of 'menu_bloc.dart';

class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

class MenuLoading extends MenuState {
  const MenuLoading();

  @override
  List<Object> get props => [];
}

class MenuSuccess extends MenuState {
  const MenuSuccess();

  @override
  List<Object> get props => [];
}

class MenuError extends MenuState {
  final String error;

  const MenuError(this.error);

  @override
  List<Object> get props => [error];
}
