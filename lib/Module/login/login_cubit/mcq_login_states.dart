import 'package:firebase_auth/firebase_auth.dart';

abstract class McqLoginStates {}

class McqLoginInitialState extends McqLoginStates {}

class McqLoginLoadingStates extends McqLoginStates {}

class McqLoginErrorStates extends McqLoginStates {
  final String error;

  McqLoginErrorStates(this.error);
}

class McqRegisterLoadingStates extends McqLoginStates {}

class McqRegisterSuccessStates extends McqLoginStates {}

class McqRegisterErrorStates extends McqLoginStates {
  final String error;

  McqRegisterErrorStates(this.error);
}

class McqLoginSuccessStates extends McqLoginStates {
}

class McqRegisterInitialStates extends McqLoginStates {}

class McqCreateUserSuccessStates extends McqLoginStates {}

class McqCreateUserErrorStates extends McqLoginStates {
  final String error;

  McqCreateUserErrorStates(this.error);
}

class McqSignInWithGoogleSuccessStates extends McqLoginStates {
  final UserCredential userCredential;

  McqSignInWithGoogleSuccessStates(this.userCredential);
}

class McqSignInWithGoogleLoadingStates extends McqLoginStates {}

class McqSignInWithGoogleErrorStates extends McqLoginStates {
  final String error;

  McqSignInWithGoogleErrorStates(this.error);
}

class McqSignInWithFacebookLoadingStates extends McqLoginStates {}

class McqSignInWithFacebookSuccessStates extends McqLoginStates {}

class McqSignInWithFacebookErrorStates extends McqLoginStates {
  final String error;

  McqSignInWithFacebookErrorStates(this.error);
}
