import 'package:call_me/modules/login/cubit/states.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  // login user

  void loginUser({required String email, required String password}) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      if (error.runtimeType == FirebaseAuthException ||
          error.runtimeType == FirebaseException ||
          error.runtimeType == AssertionError) {
        toastMessage(
          message: 'يرجى التأكد من صحة البريد الإلكتروني أو كلمة المرور',
        );
      }
      emit(LoginErrorState(error));
    });
  }
}
