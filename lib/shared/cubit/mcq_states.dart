abstract class McqStates {}

class McqInitial extends McqStates {}

class McqLoading extends McqStates {}

class ToggleLanguage extends McqStates {}

class McqLast extends McqStates {}

class McqNext extends McqStates {}

class McqReset extends McqStates {}

class McqPrevious extends McqStates {}

class McqCurrentQuestion extends McqStates {
  int index;

  McqCurrentQuestion(this.index);
}

class McqCorrect extends McqStates {
  bool isCorrect = true;

  McqCorrect(this.isCorrect);
}

class McqWrong extends McqStates {
  bool isWrong = false;

  McqWrong(this.isWrong);
}
