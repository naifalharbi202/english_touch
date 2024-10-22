import 'package:call_me/generated/l10n.dart';
import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/home.dart';

import 'package:call_me/modules/login/cubit/cubit.dart';
import 'package:call_me/modules/login/cubit/states.dart';
import 'package:call_me/modules/login/forgot_pass_screen.dart';
import 'package:call_me/modules/milestone/milestone_screen.dart';
import 'package:call_me/modules/register/register_screen.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/dimentions.dart';
import 'package:call_me/shared/local/cachehelper.dart';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final passFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            CacheHelper.saveData(key: 'token', value: state.token)
                .then((value) {
              token = state.token!;
            }).then((value) {
              print('Success LOGIN');
              AppCubit.get(context).getUser();
              AppCubit.get(context).getCards();
              AppCubit.get(context).currentIndex = 0;
              navigateAndFinish(context, const HomeLayout());
            });
          }
        },
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return Scaffold(
            body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // App Bar
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadiusDirectional.only(
                                bottomEnd: Radius.circular(60.0)),
                            gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 10, 98, 92),
                                  const Color.fromARGB(255, 40, 204, 188)
                                      .withOpacity(0.7),
                                ],
                                begin: Alignment.center,
                                end: Alignment.bottomCenter),
                          ),
                          width: double.infinity,
                          height: 300,
                        ),
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/images/user.png'),
                        ),
                        Positioned(
                          bottom: Dimensions.size(10, context),
                          right: langCode == 'ar'
                              ? Dimensions.size(10, context)
                              : 0,
                          left: langCode == 'ar'
                              ? 0
                              : Dimensions.size(10, context),
                          child: Text(
                            S.of(context).sign_in,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Column(
                        children: [
                          //email field
                          defaultTextFormField(
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              label: S.of(context).email,
                              onFieldSubmitted: (value) {
                                passFieldFocusNode.requestFocus();
                              },
                              suffixIcon: Icons.email,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return S.of(context).required_field;
                                }
                                return null;
                              }),
                          const SizedBox(
                            height: 15.0,
                          ),
                          //pass field
                          defaultTextFormField(
                              controller: passController,
                              isPassword: cubit.isPassword,
                              focusNode: passFieldFocusNode,
                              type: TextInputType.text,
                              label: S.of(context).password,
                              textInputAction: TextInputAction.done,
                              suffixIcon: cubit.suffixIcon,
                              onSuffixPress: () {
                                cubit.showPasswordVisibility();
                              },
                              onChange: (value) {
                                cubit.isPasswordUnderSix(value);
                              },
                              onFieldSubmitted: (value) {
                                if (formKey.currentState!.validate()) {
                                  Map<String, dynamic> creds = {
                                    "email": emailController.text,
                                    "password": passController.text,
                                    "device_name":
                                        "default", // Use device info instead of this
                                  };
                                  cubit.login(creds: creds);
                                }
                              },
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return S.of(context).required_field;
                                }
                                return null;
                              }),
                          SizedBox(
                            height: Dimensions.size(5, context),
                          ),
                          // Check password digits
                          if (cubit.isPassUnderSix == true)
                            Container(
                              width: double.infinity,
                              color: Colors.red[500],
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.size(8, context)),
                                child: Text(
                                  S.of(context).must_be_six_digits,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),

                          ConditionalBuilder(
                            condition: state is! LoginLoadingState,
                            builder: (context) => // sign up button //
                                defaultButton(
                              text: S.of(context).sign_in,
                              onPress: () {
                                if (formKey.currentState!.validate()) {
                                  Map<String, dynamic> creds = {
                                    "email": emailController.text,
                                    "password": passController.text,
                                    "device_name":
                                        "default", // needs to be changed
                                  };
                                  cubit.login(creds: creds);
                                }
                              },
                            ),
                            fallback: (context) => JumpingDots(
                              color: Colors.orange,
                            ),
                          ),

                          // text button
                          Row(
                            children: [
                              // New Member
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () {
                                    navigatTo(context, RegisterScreen());
                                  },
                                  icon: const Icon(
                                    Icons.verified_user_outlined,
                                    color: Colors.orange,
                                  ),
                                  label: Text(
                                    S.of(context).new_member,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ),

                              // Forgot Password

                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () {
                                    navigatTo(context, ForgetPasswordScreen());
                                  },
                                  icon: const Icon(
                                    Icons.lock_outline,
                                    color: Color.fromARGB(255, 160, 139, 107),
                                  ),
                                  label: Text(
                                    textAlign: TextAlign.start,
                                    S.of(context).forgot_password,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            fontSize:
                                                Dimensions.size(12.5, context)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
