import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcq/shared/cubit/mcq_cubit.dart';
import 'package:mcq/shared/cubit/mcq_states.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<McqCubit, McqStates>(
      listener: (context, state) {},
      builder: (context, state) {
        McqCubit mainCubit = BlocProvider.of<McqCubit>(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'MCQ',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          backgroundColor: Colors.indigo,
          body: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(mainCubit.totalScore/mainCubit.totalQuestions < 0.5)
                    Text(
                      'Hard Luck!',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if(mainCubit.totalScore/mainCubit.totalQuestions >= 0.5)
                  Text(
                    'Congratulations!',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Your Score: ${mainCubit.totalScore}/${mainCubit.totalQuestions}',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: MaterialButton(
                      elevation: 10,
                      color: Colors.deepOrange,
                      child: Text('Restart Quiz',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                      onPressed: () {
                        mainCubit.resetQuiz(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
