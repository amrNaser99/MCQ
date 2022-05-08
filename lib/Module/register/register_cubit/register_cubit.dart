import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcq/Module/register/register_cubit/register_states.dart';
import 'package:mcq/model/user_model.dart';
import 'package:mcq/network/local/cache_helper.dart';
import 'package:mcq/shared/components/constants.dart';

class McqRegisterCubit extends Cubit<McqRegisterStates> {
  McqRegisterCubit() : super(McqRegisterInitialStates());

  static McqRegisterCubit get(context) => BlocProvider.of(context);

  //Register
  UserCredential? localCredential;
  UserModel? userModel;

  Future<void> userRegister({
    required String userName,
    required String? phone,
    required String email,
    required String password,
    required String vPassword,
  }) async {
    emit(McqRegisterLoadingStates());

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      localCredential = value;

      userCreate(
        userName: userName,
        email: email,
        phone: phone!,
        uId: value.user!.uid,
      );

      print('after user create');
      CacheHelper.saveData(key: 'uId', value: value.user!.uid).then((value) {
        value
            ? print('uId saved in Cache Memory Successfully')
            : print('Failed save uId in Cache Memory');
      });
      print('after save uId');
      uId = value.user!.uid;
      print(uId);
      token = value.credential!.token;

      print('after save token and uId');
      emit(McqRegisterSuccessStates());
    }).catchError((error) {
      emit(McqRegisterErrorStates(error.toString()));
    });
  }

  // Cloud FireStore Create

  void userCreate({
    required String userName,
    required String email,
    required String? phone,
    required String uId,
  }) {
    emit(McqRegisterLoadingStates());

    userModel = UserModel(
      userName: userName,
      email: email,
      phone: phone,
      uId: uId,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel!.toMap())
        .then((value) {
      print('user created successfully in firestore');
      emit(McqCreateUserSuccessStates());
    }).catchError((error) {
      emit(McqCreateUserErrorStates(error));
    });
  }
}
