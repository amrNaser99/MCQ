import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mcq/Module/login/login_cubit/mcq_login_cubit.dart';
import 'package:mcq/Module/register/register_cubit/register_cubit.dart';
import 'package:mcq/layout/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mcq/network/local/cache_helper.dart';
import 'package:mcq/shared/bloc_observer.dart';
import 'package:mcq/shared/components/applocale.dart';
import 'package:mcq/shared/components/constants.dart';
import 'package:mcq/shared/cubit/mcq_cubit.dart';
import 'package:mcq/shared/cubit/mcq_states.dart';
import 'package:mcq/shared/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp();

  uId = CacheHelper.getData(key: 'uId');
  BlocOverrides.runZoned(
    () {
      runApp(const SplashScreen());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatefulWidget {
  final Widget? startWidget;

  const MyApp({Key? key, this.startWidget}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => McqCubit(),
        ),
        BlocProvider(
          create: (context) => McqLoginCubit(),
        ),
        BlocProvider(
          create: (context) => McqRegisterCubit(),
        )
      ],
      child: BlocConsumer<McqCubit, McqStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocale.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            locale: BlocProvider.of<McqCubit>(context).checked
                ? const Locale('ar', "")
                : const Locale('en', ""),
            supportedLocales: const [
              Locale('en', ''),
              Locale('ar', ''),
            ],
            localeResolutionCallback: (currentLang, supportLang) {
              if (currentLang != null) {
                for (Locale locale in supportLang) {
                  if (locale.languageCode == currentLang.languageCode) {
                    return currentLang;
                  }
                }
              }
              return supportLang.first;
            },
            title: 'MCQ',
            theme: lightMode,
            themeMode: ThemeMode.light,
            home: widget.startWidget,
          );
        },
      ),
    );
  }
}
