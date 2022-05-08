import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcq/network/local/cache_helper.dart';
import 'package:mcq/Module/login/login_cubit/mcq_login_states.dart';
import 'package:mcq/shared/components/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

class McqLoginCubit extends Cubit<McqLoginStates> {
  McqLoginCubit() : super(McqLoginInitialState());

  static McqLoginCubit get(context) => BlocProvider.of(context);

  FirebaseAuth auth = FirebaseAuth.instance;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(McqLoginLoadingStates());
    print('in userLogin');

    auth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print('==========================');
      CacheHelper.saveData(key: 'email', value: value.user!.email);
      CacheHelper.saveData(key: 'uId', value: value.user!.uid);
      CacheHelper.saveData(key: 'uId', value: value.credential!.token!);
      uId = value.user!.uid;
      print(value.user!.uid);

      emit(McqLoginSuccessStates());
    }).catchError((error) {
      emit(McqLoginErrorStates(error.toString()));
    });
  }

  UserCredential? userCredential;

  Future signInWithGoogle() async {
    emit(McqSignInWithGoogleLoadingStates());
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print('==========================');
    await FirebaseAuth.instance.signInWithCredential(credential)
        .then((value) {
      userCredential = value;
      emit(McqSignInWithGoogleSuccessStates(value));
    }).catchError((error) {
      emit(McqSignInWithGoogleErrorStates(error.toString()));
    });
  }
  //
  // Future<UserCredential> signInWithFacebook() async {
  //   emit(McqSignInWithFacebookLoadingStates());
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login();
  //
  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //
  //   // Once signed in, return the UserCredential
  //   var a = await FirebaseAuth.instance
  //       .signInWithCredential(facebookAuthCredential)
  //       .then((value) {
  //     CacheHelper.saveData(key: 'email', value: value.user?.email);
  //     CacheHelper.saveData(key: 'uId', value: value.user?.uid);
  //     CacheHelper.saveData(key: 'token', value: value.credential?.token!);
  //
  //     emit(McqSignInWithFacebookSuccessStates());
  //   }).catchError((error) {
  //     emit(McqSignInWithFacebookErrorStates(error.toString()));
  //   });
  //   return a;
  // }
}
