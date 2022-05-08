import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcq/model/boarding_model.dart';
import 'package:mcq/network/local/cache_helper.dart';
import 'package:mcq/shared/components/applocale.dart';
import 'package:mcq/shared/cubit/mcq_cubit.dart';
import 'package:mcq/shared/cubit/mcq_states.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:mcq/shared/components/components.dart';
import 'package:mcq/shared/styles/colors.dart';
import '../start_screen/start_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  var boardingController = PageController();
  bool isLast = false;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<McqCubit>(context).switchController.addListener(() {
      BlocProvider.of<McqCubit>(context).toggleLang();
    });
  }

// ...
  void submit() {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value) {
        NavigateAndFinish(
          context,
          const StartScreen(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<McqCubit, McqStates>(
      listener: (context, state) {},
      builder: (context, state) {

        List<BoardingModel> boardingList = [
          BoardingModel(
            image: 'assets/images/m_c_q.png',
            title: getLang(context, "Multiple Choice Questions"),
            body: getLang(context, "Provides Multiple Choice Questions"),
          ),
          BoardingModel(
            image: 'assets/images/to_easy.jpg',
            title: getLang(context, "Too Many Questions"),
            body: getLang(context, "Many questions in various fields"),
          ),
          BoardingModel(
            image: 'assets/images/calc.png',
            title: getLang(context, "calculate your score"),
            body: getLang(context, "calculate your score and get your rank"),
          ),
        ];

        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: AdvancedSwitch(
              controller: BlocProvider.of<McqCubit>(context).switchController,
              activeColor: Colors.deepPurpleAccent,
              activeChild: const Text('en'),
              inactiveColor: Colors.indigo.shade400,
              inactiveChild: const Text('ar'),
              enabled: true,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  submit();
                },
                child: const Text(
                  'SKIP',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.indigo,
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Expanded(
                    child: PageView.builder(
                  itemBuilder: (context, index) =>
                      buildBoardingItem(boardingList[index]),
                  controller: boardingController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (int index) {
                    if (index == boardingList.length - 1) {
                      setState(() {
                        isLast = true;
                      });
                    } else {
                      setState(() {
                        isLast = false;
                      });
                    }
                  },
                  itemCount: boardingList.length,
                )),
                const SizedBox(
                  height: 50.0,
                ),
                Row(
                  children: [
                    SmoothPageIndicator(
                      controller: boardingController,
                      effect: const ExpandingDotsEffect(
                        dotColor: Colors.white,
                        activeDotColor: Colors.deepOrange,
                        dotWidth: 10,
                        dotHeight: 10,
                        expansionFactor: 4,
                        spacing: 5,
                      ),
                      count: boardingList.length,
                    ),
                    const Spacer(),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () {
                        if (isLast == true) {
                          submit();
                        } else {
                          boardingController.nextPage(
                            duration: const Duration(milliseconds: 750),
                            curve: Curves.fastOutSlowIn,
                          );
                        }
                      },
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: mainColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget buildBoardingItem(BoardingModel model) => Container(
      height: 100.0,
      color: Colors.indigo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: AssetImage(model.image!),
            ),
          ),
          const SizedBox(
            height: 40.0,
          ),
          Text(
            model.title!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            model.body!,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
