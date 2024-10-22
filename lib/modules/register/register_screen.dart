import 'package:call_me/generated/l10n.dart';
import 'package:call_me/modules/login/login_screen.dart';
import 'package:call_me/modules/register/cubit/cubit.dart';
import 'package:call_me/modules/register/cubit/states.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/dimentions.dart';
import 'package:call_me/shared/local/cachehelper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final phoneController = TextEditingController();
  final emailFieldFocus = FocusNode();
  final phoneFieldFocus = FocusNode();
  final passFieldFocus = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (context, state) {
        if (state is CreateUserSuccessState) {
          navigateAndFinish(context, LoginScreen());
        }
      }, builder: (context, state) {
        RegisterCubit cubit = RegisterCubit.get(context);
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
                        right:
                            langCode == 'ar' ? Dimensions.size(10, context) : 0,
                        left:
                            langCode == 'ar' ? 0 : Dimensions.size(10, context),
                        child: Text(
                          S.of(context).new_register,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        //name field
                        defaultTextFormField(
                            controller: nameController,
                            type: TextInputType.text,
                            label: S.of(context).username,
                            suffixIcon: Icons.person,
                            onFieldSubmitted: (value) {
                              phoneFieldFocus.requestFocus();
                            },
                            textInputAction: TextInputAction.next,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return S.of(context).required_field;
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 15.0,
                        ),

                        const SizedBox(
                          height: 15.0,
                        ),
                        //phone field
                        defaultTextFormField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            label: S.of(context).phone,
                            suffixIcon: Icons.call,
                            onFieldSubmitted: (value) {
                              emailFieldFocus.requestFocus();
                            },
                            textInputAction: TextInputAction.next,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return S.of(context).required_field;
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 15.0,
                        ),
                        //email field
                        defaultTextFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            label: S.of(context).email,
                            suffixIcon: Icons.email,
                            onFieldSubmitted: (value) {
                              passFieldFocus.requestFocus();
                            },
                            textInputAction: TextInputAction.next,
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
                            type: TextInputType.visiblePassword,
                            label: S.of(context).password,
                            suffixIcon: cubit.suffixIcon,
                            onSuffixPress: () {
                              cubit.showPasswordVisibility();
                            },
                            onChange: (value) {
                              cubit.isPasswordUnderSix(value);
                            },
                            onFieldSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                cubit.registerUser(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            textInputAction: TextInputAction.done,
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
                        const SizedBox(
                          height: 20.0,
                        ),
                        // sign up button //
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
                          builder: (context) => defaultButton(
                            text: S.of(context).register,
                            onPress: () {
                              if (formKey.currentState!.validate()) {
                                cubit.registerUser(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                          ),
                          fallback: (context) => JumpingDots(
                            color: Colors.orange,
                          ),
                        ),

                        // text button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                                onPressed: () {
                                  navigatTo(context, LoginScreen());
                                },
                                icon: const Icon(
                                  Icons.verified_user_outlined,
                                  color: Colors.orange,
                                ),
                                label: Text(S.of(context).have_an_accont,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
