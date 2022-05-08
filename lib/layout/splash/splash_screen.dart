import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../Module/onBoarding/onBoarding.dart';
import '../../shared/components/constants.dart';
import '../mcq_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {



  @override
  Widget build(BuildContext context) {

    late Widget widget;
    if (uId != null) {
      widget = const McqLayout();
    } else {
      widget = const OnBoardingScreen();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        body: EasySplashScreen(
          logo: Image.asset(
            'assets/images/logo.png',
          ),
          durationInSeconds: 2,
          logoSize: 200,
          loadingText: const Text('Developed By Amr Nasser',style: TextStyle(fontWeight: FontWeight.bold),),
          showLoader: true,
          navigator: MyApp(
            startWidget: widget,
          ),
        ),
      ),
    );
  }
}
