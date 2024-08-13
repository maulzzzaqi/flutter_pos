part of 'auth_bloc.dart';

class AuthState extends Equatable  {
  final User? userData;
  final bool isLoading;
  final String errorMessage;
  final String? name;
  final String? phoneNumber;
  final String? profileImageUrl;

  const AuthState({this.userData, this.isLoading = false, this.errorMessage = '', this.name, this.phoneNumber, this.profileImageUrl});

  AuthState copyWith({
    User? userData,
    bool? isLoading,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      userData: userData ?? this.userData,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [userData, isLoading, errorMessage, name, phoneNumber, profileImageUrl];
}
