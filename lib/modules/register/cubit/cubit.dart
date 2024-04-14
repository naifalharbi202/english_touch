import 'package:call_me/models/user_model.dart';
import 'package:call_me/modules/register/cubit/states.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  //Register user
  void registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(RegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(
        name: name,
        email: email,
        password: password,
        phone: phone,
        uid: value.user!.uid, // uid will be created when register success
      );
    }).catchError((error) {
      toastMessage(message: error.toString());
      emit(RegisterErrorState(error));
    });
  }

//Save user data in firestore
  void createUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String uid,
  }) {
    UserModel userModel = UserModel(
      name,
      email,
      password,
      phone,
      uid,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userModel.toJson())
        .then((value) {
      emit(CreateUserSuccessState(uid));
    }).catchError((error) {
      toastMessage(message: error.toString());
      emit(CreateUserErrorState(error));
    });
  }
}
