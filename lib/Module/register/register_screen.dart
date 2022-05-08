import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcq/Module/login/mcq_login_screen.dart';
import 'package:mcq/Module/register/register_cubit/register_cubit.dart';
import 'package:mcq/Module/register/register_cubit/register_states.dart';
import 'package:mcq/layout/mcq_layout.dart';
import 'package:mcq/shared/components/components.dart';
import 'package:mcq/shared/styles/colors.dart';

class McqRegisterScreen extends StatefulWidget {
  const McqRegisterScreen({Key? key}) : super(key: key);

  @override
  State<McqRegisterScreen> createState() => _McqRegisterScreenState();
}

class _McqRegisterScreenState extends State<McqRegisterScreen> {
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  TextEditingController? phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var verifyPasswordController = TextEditingController();
  var isPassword = true;
  var isVerifyPassword = true;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<McqRegisterCubit, McqRegisterStates>(
      listener: (context, state) {
        if (state is McqRegisterErrorStates) {
          print(state.error.toString());
          showToast(message: state.error);
        }
        if (state is McqCreateUserSuccessStates) {
          NavigateAndFinish(context, const McqLayout());
          showToast(message: 'Register Done Successfully');
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SIGN UP',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                            ),
                            Text(
                              'Register Now To Have an Account',
                              style:
                                  Theme.of(context).textTheme.caption?.copyWith(
                                        color: colorGreyDark,
                                        fontSize: 14.0,
                                      ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultTextFormField(
                          controller: userNameController,
                          keyboardType: TextInputType.text,
                          labelText: 'UserName',
                          prefixIcon: Icons.alternate_email_outlined,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Your Email Address';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultTextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          labelText: 'Email',
                          hintText: 'Email Address',
                          prefixIcon: Icons.email_outlined,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Your Email Address';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultTextFormField(
                          controller: phoneController!,
                          keyboardType: TextInputType.phone,
                          labelText: 'Phone',
                          hintText: '+01*********',
                          // validate: (value){
                          //   if(value!.length != 10){
                          //     return 'Please Enter a Valid Number';
                          //   }
                          // },
                          prefixIcon: Icons.local_phone_outlined,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultTextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            labelText: 'Password',
                            prefixIcon: Icons.lock_outline,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password Must\'t Be Empty';
                              }
                            },
                            isPassword: isPassword,
                            suffixIcon: isPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            suffixPressed: () {
                              setState(() {
                                isPassword = !isPassword;
                              });
                            }),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultTextFormField(
                            controller: verifyPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            labelText: 'Verify Password',
                            prefixIcon: Icons.lock_outline,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password Must\'t Be Empty';
                              }
                              if (value != passwordController.text) {
                                return 'Re-Enter The Password';
                              }
                            },
                            isPassword: isVerifyPassword,
                            suffixIcon: isVerifyPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            suffixPressed: () {
                              setState(() {
                                isVerifyPassword = !isVerifyPassword;
                              });
                            }),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! McqRegisterLoadingStates,
                          builder: (context) => defaultButton(
                            color: primaryColor,
                            text: 'Register',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                //TODO link to api and register

                                McqRegisterCubit.get(context).userRegister(
                                  userName: userNameController.text,
                                  email: emailController.text,
                                  phone: phoneController?.text,
                                  password: passwordController.text,
                                  vPassword: verifyPasswordController.text,
                                );
                              }
                            },
                            isUpperCase: true,
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already Have Account?'),
                            defaultTextButton(
                              onPressed: () {
                                NavigateAndFinish(
                                    context, const McqLoginScreen());
                              },
                              text: 'Login',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }
}
