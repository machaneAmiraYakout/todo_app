import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_flutter/shared/components/components.dart';
import 'package:learn_flutter/shared/cubit/cubit.dart';
import 'package:learn_flutter/shared/cubit/states.dart';
import '../../shared/components/constants.dart';

class NewTaskScreen extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state){},
      builder: (context, state){
        var tasksCubit=AppCubit.get(context).newtasks;
        return TasksBuilder(
            tasks: tasksCubit
        );
      },
    );



  }
}
