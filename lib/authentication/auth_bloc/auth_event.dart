part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthRegister extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String phoneNumber;

  const AuthRegister(
      {required this.email,
      required this.password,
      required this.name,
      required this.phoneNumber});

  @override
  List<Object> get props => [email, password, name, phoneNumber];
}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthLogin({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthCheck extends AuthEvent {
  const AuthCheck();

  @override
  List<Object> get props => [];
}

class AuthUpdate extends AuthEvent {
  final String name;
  final String phoneNumber;

  const AuthUpdate({required this.name, required this.phoneNumber});

  @override
  List<Object> get props => [name, phoneNumber];
}

class AuthLogout extends AuthEvent {
  const AuthLogout();

  @override
  List<Object> get props => [];
}
