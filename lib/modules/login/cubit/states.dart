import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final String? uId; // to save it

  LoginSuccessState(this.uId);
}

class LoginErrorState extends LoginStates {
  final FirebaseAuthException? error;

  LoginErrorState(this.error);
}

class LoginShowPasswordState extends LoginStates {}

class PasswordChangeState extends LoginStates {}
