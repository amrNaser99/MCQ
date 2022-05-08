import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mcq/model/question_model.dart';
import 'package:mcq/shared/cubit/mcq_cubit.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/icon_broken.dart';

Widget defaultButton({
  double width = double.infinity,
  Color? color,
  required String text,
  required void Function() onPressed,
  bool isUpperCase = true,
  var padding = EdgeInsets.zero,
}) =>
    Padding(
      padding: padding,
      child: Container(
        width: width,
        height: 40.0,
        child: MaterialButton(
          child: Text(
            isUpperCase ? text.toUpperCase() : text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: onPressed,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.indigo,
        ),
      ),
    );

void NavigateTo(context, Widget widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void NavigateAndFinish(context, Widget widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String? labelText,
  String? hintText,
  required IconData prefixIcon,
  FormFieldValidator<String>? validate,
  IconData? suffixIcon,
  void Function(String)? onSubmitted,
  void Function(String)? onChanged,
  void Function()? onTap,
  void Function()? suffixPressed,
  bool isPassword = false,
  double radius = 10.0,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius)),
        prefixIcon: Icon(prefixIcon),
        hintText: hintText,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: suffixPressed,
              )
            : null,
      ),
      onChanged: onChanged,
      onTap: onTap,
      validator: validate,
      onFieldSubmitted: onSubmitted,
    );

Widget defaultTextButton({
  required Function()? onPressed,
  required String text,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
      ),
    );

void showToast({
  required String message,
  bool isShort = false,
}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: isShort ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      // backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) =>
    AppBar(
      leading: IconButton(
        icon: const Icon(IconBroken.Arrow___Left_2),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      titleSpacing: 5.0,
      title: Text(title!),
      actions: actions,
    );

Widget buildQuestionModel(
  BuildContext context,
  QuestionModel questionModel,
) {
  McqCubit mainCubit = BlocProvider.of<McqCubit>(context);
  List _answers = questionModel.answer!.keys.toList();

  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).padding.horizontal + 20.0,
      vertical: MediaQuery.of(context).size.height * 0.05, //20.0,
    ),
    child: Column(
      children: [
        Text(
          // 'What is the name of the first Indian to win the gold in the Olympics?',
          questionModel.question!,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: mainCubit.isPress
                ? questionModel.answer![_answers[0]]!
                    ? Colors.green
                    : Colors.red
                : Colors.indigo,
          ),
          child: MaterialButton(
            onPressed: () {
              mainCubit.checkAnswer(questionModel.answer![_answers[0]]!,_answers[0]);
            },
            child: Text(
              _answers[0].toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Container(
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: mainCubit.isPress
                  ? questionModel.answer![_answers[1]]!
                      ? Colors.green
                      : Colors.red
                  : Colors.indigo,
            ),
            child: MaterialButton(
              onPressed: () {
                mainCubit.checkAnswer(questionModel.answer![_answers[1]]!,_answers[1]);
              },
              child: Text(
                _answers[1].toString(),
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
            )),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Container(
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: mainCubit.isPress
                  ? questionModel.answer![_answers[2]]!
                      ? Colors.green
                      : Colors.red
                  : Colors.indigo,
            ),
            child: MaterialButton(
              onPressed: () {
                mainCubit.isPress = true;
                mainCubit.checkAnswer(questionModel.answer![_answers[2]]!,_answers[2]);
              },
              child: Text(
                _answers[2].toString(),
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
            )),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: mainCubit.isPress
                ? questionModel.answer![_answers[3]]!
                    ? Colors.green
                    : Colors.red
                : Colors.indigo,
          ),
          child: MaterialButton(
            onPressed: () {
              mainCubit.isPress = true;
              mainCubit.checkAnswer(questionModel.answer![_answers[3]]!,_answers[3]);
            },
            child: Text(
              _answers[3].toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}
