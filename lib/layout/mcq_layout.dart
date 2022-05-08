import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcq/Module/home/home_screen.dart';
import 'package:mcq/Module/login/login_cubit/mcq_login_cubit.dart';
import 'package:mcq/Module/register/register_cubit/register_cubit.dart';
import 'package:mcq/model/user_model.dart';
import 'package:mcq/shared/components/components.dart';
import 'package:mcq/shared/cubit/mcq_cubit.dart';
import 'package:mcq/shared/cubit/mcq_states.dart';
import '../Module/start_screen/start_screen.dart';
import '../network/local/cache_helper.dart';
import '../shared/components/constants.dart';

class McqLayout extends StatelessWidget {
  const McqLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<McqCubit, McqStates>(
      listener: (context, state) {},
      builder: (context, state) {
        McqLoginCubit loginCubit = BlocProvider.of(context);
        McqRegisterCubit registerCubit = BlocProvider.of(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'MCQ',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    token = null;
                    uId = null;
                    CacheHelper.clearCache();
                    NavigateTo(context, const StartScreen());
                  }).catchError((error) {});
                },
                child: const Text(
                  'SIGN OUT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'janna',
                  ),
                ),
              )
            ],
          ),
          backgroundColor: Colors.indigo,
          body: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (loginCubit.userCredential != null)
                    Text(
                      loginCubit.userCredential!.user!.displayName!
                          .toUpperCase(),
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  if (registerCubit.userModel != null)
                    Text(
                      registerCubit.userModel!.userName!.toUpperCase(),
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  Text(
                    'Let\'s Play Quiz, ',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: MaterialButton(
                        elevation: 10,
                        color: Colors.deepOrange,
                        child: Text('Go',
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )),
                        onPressed: () {
                          NavigateAndFinish(context, const HomeScreen());
                        }),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
