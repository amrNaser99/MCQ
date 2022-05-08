abstract class McqRegisterStates {}

class McqRegisterInitialStates extends McqRegisterStates {}

class McqRegisterLoadingStates extends McqRegisterStates {}

class McqRegisterSuccessStates extends McqRegisterStates {}

class McqRegisterErrorStates extends McqRegisterStates {
  final String error;

  McqRegisterErrorStates(this.error);
}

class McqCreateUserSuccessStates extends McqRegisterStates {}

class McqCreateUserErrorStates extends McqRegisterStates {
  final String error;

  McqCreateUserErrorStates(this.error);
}
