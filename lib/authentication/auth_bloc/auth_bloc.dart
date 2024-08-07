import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<AuthEvent>((event, emit) {
      on<AuthRegister>((event, emit) async {
        emit(const AuthState(isLoading: true));
        try {
          // Initialize Register
          final auth = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
          // Add more user information
          await FirebaseFirestore.instance.collection('users').doc(auth.user!.uid).set({
            'name': event.name,
            'phoneNumber': event.phoneNumber,
            'email': event.email,
          });
          emit(AuthState(userData: auth.user));
        } catch (e) {
          emit(AuthState(errorMessage: e.toString()));
        }
      });
      on<AuthLogin>((event, emit) async {
        emit(const AuthState(isLoading: true));
        try {
          final auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email,
            password: event.password
          );
          emit(AuthState(userData: auth.user)); 
        } catch (e) {
          emit(AuthState(errorMessage: e.toString()));
        }
      });
      on<AuthLogout>((event, emit) async {
        await FirebaseAuth.instance.signOut();
        emit(const AuthState());
      });
    });
  }
}
