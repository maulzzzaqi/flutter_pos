part of 'auth_bloc.dart';

class AuthState extends Equatable  {
  final User? userData;
  final bool isLoading;
  final String errorMessage;
  final String? name;
  final String? phoneNumber;

  const AuthState({this.userData, this.isLoading = false, this.errorMessage = '', this.name, this.phoneNumber});

  @override
  List<Object?> get props => [userData, isLoading, errorMessage, name, phoneNumber];
}
