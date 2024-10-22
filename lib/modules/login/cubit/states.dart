import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final String? token; // to save it

  LoginSuccessState(this.token);
}

class LoginErrorState extends LoginStates {
  LoginErrorState();
}

class LoginShowPasswordState extends LoginStates {}

class PasswordChangeState extends LoginStates {}

/// LARAVEL SPOT /////

class SaveTokenSuccessState extends LoginStates {}

class SaveTokenLoadinfState extends LoginStates {}

class SaveTokenErrorState extends LoginStates {}
