
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_flutter/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';


import '../../modules/arckived_tasks/arckived_tasks.dart';
import '../../modules/done_tasks/done_tasks.dart';
import '../../modules/new_tasks/new_tasks.dart';
import '../components/constants.dart';

class AppCubit extends Cubit<AppStates>{
   AppCubit():super(AppInititState());
  static AppCubit get(context)=>BlocProvider.of(context);
  int currentindex=0;
  List<String> titles =['New Tasks','Done Tasks','Archived Tasks'];
  List<Widget> screens =[
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchiveTaskScreen(),
  ];
void changeIndex(index){
  currentindex=index;
  emit(AppChangeNavBarBottomState());
}

late Database database;
   List<Map> newtasks=[];
   List<Map> donetasks=[];
   List<Map> archivetasks=[];


  void CreateDatabase() {
     openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database, version)
        {
          print('database created');
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, data TEXT, time TEXT, status TEXT)').then((value){
            print('table created');
          }).catchError((onError){
            print('error whene creating the table${onError.toString()}');
          });
        },

        onOpen: (database)
        {
          GetDataFromDatabase(database);
          print('database opened');

        }

    ).then((value){
      database=value;
      emit(AppCreateDatabaseState());
     });
  }

//insert
  Future  InsertToDatabase({
    required String title,
    required String time,
    required String date,})async{
     await  database.transaction((txn) async{
      txn.rawInsert('INSERT INTO tasks (title, data, time, status ) VALUES("$title","$date","$time","new")')
          .then((value){
            emit(AppInsertDatabaseState());

            GetDataFromDatabase(database);

        print('$value inserted successfuly');
      }).catchError((onError){
        print('error when inserting into table ${onError.toString()}');
      }) ;

    });
  }
//get
  void GetDataFromDatabase(database){
    newtasks=[];
    donetasks=[];
    archivetasks=[];
    emit(AppGetDatabaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value) {
       value.forEach((element){
         if(element['status']== 'new') newtasks.add(element);
         else if(element['status']=='done') donetasks.add(element);
         else archivetasks.add(element);

       });
       emit(AppGetDatabaseState());
     });
  }


   bool bottomsheetopen= false;
   IconData icona=Icons.edit;

   void ChangeBottomSheetState({
     required bool isshow,
     required IconData icon})
   {
     bottomsheetopen=isshow;
     icona=icon;
     emit(AppChangBottomsheetState());

   }
   //update
   void UpdateDatabase({
     required String status,
     required int id,
   })async{
     database.rawUpdate('UPDATE tasks SET status = ? WHERE id=?',
     ['$status',id]
     ).then((value) {
       GetDataFromDatabase(database);
       emit(AppUpdateDatabaseState());
     });
   }

   void DeletefromDatabase({
  required int id ,})async
   {
     database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value){
       GetDataFromDatabase(database);
       emit(AppDeleteDatabaseState());
     });
   }
}