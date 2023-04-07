import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:learn_flutter/modules/done_tasks/done_tasks.dart';
import 'package:learn_flutter/modules/new_tasks/new_tasks.dart';

import 'package:learn_flutter/shared/cubit/cubit.dart';
import 'package:learn_flutter/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import '../shared/components/components.dart';




class HomeLayoutCubit extends StatelessWidget {

  late Database database;
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  var titleController= TextEditingController();
  var timeController= TextEditingController();
  var dateController= TextEditingController();




  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..CreateDatabase() ,
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state){
          if(state is AppInsertDatabaseState){
            Navigator.pop(context); // drna had l 9afla ta3 bottomsheet hna psq
            // koon ndirha f cubit lazm khdmaaaaa bah njib l context
            // madam ana n9dr nssm3 l state amala ng3d nssm3 l insert ki ydakhl w ykhls ana nskr
          }
        },
        builder: (BuildContext context, AppStates state){
          AppCubit cubit =AppCubit.get(context);
          return
            Scaffold(
              key: scaffoldkey, // koon madirich hada mayokhrjch bottomsheet
              appBar: AppBar(
              ),
              body: ConditionalBuilder(
                  condition: state is! AppGetDatabaseLoadingState,
                  builder: (context)=> cubit.screens[cubit.currentindex],
                  fallback: (context)=>const Center(child:CircularProgressIndicator())),
              floatingActionButton: FloatingActionButton(
                onPressed: (){
                  if(cubit.bottomsheetopen){
                    if(formkey.currentState!.validate()){
                      cubit.InsertToDatabase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text);
                    }
                  } else{
                    scaffoldkey.currentState?.showBottomSheet((context) =>
                        Container(
                          color: Colors.grey[100],
                          child: Padding(padding: EdgeInsets.all(20.0),
                              child:  Form(
                                key: formkey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DefaultFormField(
                                      emailcontroller: titleController,
                                      textType: TextInputType.text,
                                      icon: Icon( Icons.title),
                                      validator: (value){
                                        if(value.isEmpty){
                                          return 'title value must not be empty';
                                        }
                                        return null;
                                      },
                                      labelText:'Title' ,
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    DefaultFormField(
                                      emailcontroller: timeController,
                                      textType: TextInputType.text,
                                      icon: Icon( Icons.watch_later_outlined),
                                      validator: (value){
                                        if(value.isEmpty){

                                          return 'tima value must not be empty';
                                        }
                                        return null;
                                      },
                                      ontap: (){
                                        showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now()
                                        ).then((value) {
                                          timeController.text=value!.format(context).toString(); // null safety 3la value malazmch tkon null
                                        });

                                      },
                                      labelText:'Time' ,
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),//Def
                                    DefaultFormField(
                                      emailcontroller: dateController,
                                      textType: TextInputType.datetime,
                                      icon: Icon( Icons.calendar_month),
                                      validator: (value){
                                        if(value.isEmpty){

                                          return 'date value must not be empty';
                                        }
                                        return null;
                                      },
                                      ontap: (){
                                        showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.parse('2023-12-12')).then((value)
                                        {
                                          dateController.text= DateFormat.yMMMd().format(value!);
                                        });
                                      },
                                      labelText:'Date' ,
                                    ),// aultFormField

                                  ],
                                ),)
                          ),),
                      elevation: 20.0,
                    ).closed.then((value) {
                      cubit.ChangeBottomSheetState(isshow: false, icon: Icons.edit);

                    });
                    cubit.ChangeBottomSheetState(isshow: true, icon: Icons.add);
                  }

                },
                child:Icon(cubit.icona) ,),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentindex,
                onTap: (index)
                {
                  cubit.changeIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(icon:Icon(Icons.menu),label: 'Tasks' ),
                  BottomNavigationBarItem(icon: Icon(Icons.check_box_outlined),label: 'checked'),
                  BottomNavigationBarItem(icon:Icon(Icons.archive_outlined),label: 'archived' ),
                ],
              ),
            );
        },
      ),
    );
  }

}

// error with try catch :
// try{
//   var name= await GetData();
//  print(name);
// print("amira");
//   throw('there is an error here');
// } catch(error){
//   print("${error.toString()}           tfooooo");
// }

// the diffrence between try catch and then is 1 mana9drooch nodhomno
// bli print amira rah ji ba3d ma ydir print l value
// 3aks then li hata yprinti l value bah ydir print l amira sur
//GetData().then((value) {
//  print(value);
//  print('AMIRA');
// throw('yeeeeeeeeeeeeeeeeeees');

//  }).catchError((onError){
//   print('${onError.toString() }          hahahaahahahaha ');

//  });