import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcq/Module/register/register_screen.dart';
import 'package:mcq/layout/mcq_layout.dart';
import 'package:mcq/shared/components/components.dart';
import 'package:mcq/shared/components/constants.dart';
import 'package:mcq/shared/styles/colors.dart';
import 'login_cubit/mcq_login_cubit.dart';
import 'login_cubit/mcq_login_states.dart';

class McqLoginScreen extends StatefulWidget {
  const McqLoginScreen({Key? key}) : super(key: key);

  @override
  State<McqLoginScreen> createState() => _McqLoginScreenState();
}

class _McqLoginScreenState extends State<McqLoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isPassword = true;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<McqLoginCubit, McqLoginStates>(
      listener: (BuildContext context, state) {
        if (state is McqSignInWithGoogleLoadingStates) {
          const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is McqLoginSuccessStates) {
          NavigateAndFinish(
            context,
            const McqLayout(),
          );
        }
        if (state is McqSignInWithGoogleSuccessStates) {
          uId = state.userCredential.user!.uid;
          token = state.userCredential.credential!.token;
          NavigateAndFinish(context, const McqLayout());
        }
      },
      builder: (BuildContext context, state) {
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
                        Text(
                          'LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                        ),
                        Text(
                          'Login Now To Browse Our Offers',
                          style: Theme.of(context).textTheme.caption?.copyWith(
                                color: Colors.grey,
                                fontSize: 14.0,
                              ),
                        ),
                        const SizedBox(
                          height: 30.0,
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
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! McqLoginLoadingStates,
                          builder: (context) => defaultButton(
                            color: primaryColor,
                            text: 'Login',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                McqLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            isUpperCase: true,
                          ),
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Don\'t Have Account?'),
                                defaultTextButton(
                                  onPressed: () {
                                    //TODO: Change to Register Page
                                    NavigateAndFinish(
                                      context,
                                      const McqRegisterScreen(),
                                    );
                                  },
                                  text: 'Register',
                                ),
                              ],
                            ),
                            Container(
                              color: Colors.grey[300],
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.width * 0.005,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            const Text(
                              'Sign In By..',
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    //TODO SignBy Google
                                    McqLoginCubit.get(context)
                                        .signInWithGoogle();
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: MediaQuery.of(context).size.width *
                                        0.12,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey[300],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        CircleAvatar(
                                          child: Image(
                                            image: AssetImage(
                                                'assets/images/google_logo.png'),
                                          ),
                                          backgroundColor: Colors.white24,
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          'Sign in By Google',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
