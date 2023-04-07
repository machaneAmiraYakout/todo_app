import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:learn_flutter/shared/network/bloc_observer.dart';
import 'package:learn_flutter/shared/network/remote/Dio_helper.dart';

import 'layout/todo_app.dart';
import 'modules/new_tasks/new_tasks.dart';


void main() {
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return   MaterialApp(



      themeMode: ThemeMode.dark,
      home:   HomeLayoutCubit(),

      debugShowCheckedModeBanner: false,
    );
  }




}

