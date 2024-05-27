import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/cubit/states.dart';
import 'package:call_me/modules/login/login_screen.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/dimentions.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DeactivateScreen extends StatelessWidget {
  DeactivateScreen({super.key});
  final emailDeactivateController = TextEditingController();
  final passDeactivateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is DeleteUserSuccessState) {
          toastMessage(message: 'تم حذف جميع بيانات الحساب بنجاح');
          navigateAndFinish(context, LoginScreen()); //
        }
        if (state is ProvidedEmailAndPassErrorState) {
          toastMessage(message: 'البيانات المدخلة غير متطابقة');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Form(
            key: formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Email
                        defaultTextFormField(
                            controller: emailDeactivateController,
                            type: TextInputType.emailAddress,
                            label: 'البريد الإلكتروني',
                            suffixIcon: Icons.email,
                            onFieldSubmitted: (value) {},
                            textInputAction: TextInputAction.next,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'حقل مطلوب';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: Dimensions.size(10, context),
                        ),
                        defaultTextFormField(
                            controller: passDeactivateController,
                            isPassword: true,
                            type: TextInputType.visiblePassword,
                            label: 'كلمة المرور',
                            suffixIcon: Icons.lock,
                            onFieldSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                AppCubit.get(context).deactivateAccount(
                                    context,
                                    emailDeactivateController.text,
                                    passDeactivateController.text);
                              }
                            },
                            textInputAction: TextInputAction.done,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'حقل مطلوب';
                              }
                              return null;
                            }),

                        SizedBox(
                          height: Dimensions.size(10, context),
                        ),

                        ConditionalBuilder(
                            condition: state is! DeleteUserLoadingState,
                            builder: (context) => defaultButton(
                                text: 'حذف الحساب',
                                onPress: () {
                                  if (formKey.currentState!.validate()) {
                                    AppCubit.get(context).deactivateAccount(
                                        context,
                                        emailDeactivateController.text,
                                        passDeactivateController.text);
                                  }
                                }),
                            fallback: (context) => Center(
                                child: LoadingAnimationWidget.prograssiveDots(
                                    color: Colors.orange, size: 10)))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
