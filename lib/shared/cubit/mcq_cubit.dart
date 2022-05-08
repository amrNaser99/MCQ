import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mcq/Module/home/home_screen.dart';
import 'package:mcq/layout/question_list.dart';
import 'package:mcq/shared/components/components.dart';
import 'package:mcq/shared/cubit/mcq_states.dart';

class McqCubit extends Cubit<McqStates> {
  McqCubit() : super(McqInitial());

  bool checked = false;
  final switchController = ValueNotifier<bool>(false);

  PageController pageController = PageController(
    initialPage: 0,
  );
  int currentQuestion = 0;
  int totalQuestions = questionsAndAnswer.length;
  bool isLast = false;
  bool isCorrect = false;
  bool isWrong = false;
  bool isPress = false;
  int totalScore = 0;
  List totalAnswer = [];
  int finalScore = 0;

  void toggleLang(){
    if(switchController.value){
      checked = true;
    } else {
      checked = false;
    }
    emit(ToggleLanguage());
  }
  void nextQuestion() {
    if (currentQuestion == totalQuestions) {
      isLast = true;
      emit(McqLast());
    } else {
      currentQuestion = currentQuestion + 1;
      pageController.animateToPage(currentQuestion,
          duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
      print('currentQuestion: $currentQuestion');
      emit(McqNext());
    }
  }

  void previousQuestion() {
    currentQuestion = currentQuestion - 1;
    pageController.animateToPage(currentQuestion,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    print('currentQuestion: $currentQuestion');
    isLast = false;
    emit(McqPrevious());
  }

  void currentQuestionIndex(int index) {
    currentQuestion = index;
    print('currentQuestion: $currentQuestion');
    emit(McqCurrentQuestion(index));
  }

  void checkAnswer(bool answerBool, selectedAnswer) {
    {
      isPress = true;
      totalAnswer.add(selectedAnswer);
      if (answerBool == true) {
        totalScore = totalScore + 1;
        emit(McqCorrect(answerBool));
      } else {
        emit(McqWrong(answerBool));
      }
    }
  }

  void resetQuiz(BuildContext context) {
    totalAnswer.clear();
    totalScore = 0;
    isLast = false;
    currentQuestion = 0;
    isCorrect = false;
    isWrong = false;
    isPress = false;
    NavigateAndFinish(context, const HomeScreen());
    emit(McqReset());

  }
}

