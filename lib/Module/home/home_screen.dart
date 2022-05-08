import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcq/layout/question_list.dart';
import 'package:mcq/network/local/cache_helper.dart';
import 'package:mcq/shared/components/components.dart';
import 'package:mcq/shared/components/constants.dart';
import 'package:mcq/shared/cubit/mcq_cubit.dart';
import 'package:mcq/shared/cubit/mcq_states.dart';
import 'package:mcq/shared/styles/icon_broken.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../shared/cubit/mcq_cubit.dart';
import '../../shared/cubit/mcq_states.dart';
import '../score/score_screen.dart';
import '../start_screen/start_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<McqCubit, McqStates>(
      listener: (context, state) {
        if (state is McqCurrentQuestion) {
          state.index = BlocProvider.of<McqCubit>(context).currentQuestion;
        }
        if (state is McqCorrect) {

        }
        if (state is McqWrong) {
          // BlocProvider.of<McqCubit>(context).isWrong = state.isWrong;
        }
      },
      builder: (context, state) {
        McqCubit mainCubit = BlocProvider.of<McqCubit>(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            title: const Text(
              'MCQ',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'janna',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
              ),
            ],
          ),
          body: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.20,
                    decoration: const BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1),
                    child: Column(
                      children: [
                        Text(
                          'Question ${mainCubit.currentQuestion +1} of ${mainCubit.totalQuestions}',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'janna',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        StepProgressIndicator(
                          totalSteps: mainCubit.totalQuestions,
                          currentStep: mainCubit.currentQuestion + 1,
                          size: 10,
                          selectedColor: Colors.deepOrange,
                          unselectedColor: Colors.white,
                          roundedEdges: const Radius.circular(20.0),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: mainCubit.pageController,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      buildQuestionModel(context, questionsAndAnswer[index]),
                  onPageChanged: (index) {
                    mainCubit.isPress = false;
                    mainCubit.currentQuestionIndex(index);
                    if (index == questionsAndAnswer.length - 1) {
                      setState(() {
                        mainCubit.isLast = true;
                      });
                    } else {
                      setState(() {
                        mainCubit.isLast = false;
                      });
                    }
                  },
                  itemCount: questionsAndAnswer.length,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: MaterialButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            IconBroken.Arrow___Left_2,
                            color: Colors.white,
                          ),
                          Text(
                            'PREVIOUS',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onPressed: () {
                        mainCubit.previousQuestion();
                      },
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                  mainCubit.isLast == false
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: MaterialButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'NEXT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  IconBroken.Arrow___Right_2,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            onPressed: () {
                              mainCubit.nextQuestion();
                            },
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.indigo,
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: MaterialButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Score  ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  IconBroken.Arrow___Right_Square,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            onPressed: () {
                              NavigateTo(context, const ScoreScreen());
                            },
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.indigo,
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
            ],
          ),
        );
      },
    );
  }
}
