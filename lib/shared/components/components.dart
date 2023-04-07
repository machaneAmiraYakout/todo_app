

// reusable components
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/shared/cubit/cubit.dart';


Widget DefaultButton({
  double width=double.infinity,
  double height= 50.0,
  Color color=Colors.blue,
  Color colortxt = Colors.white,
  required  fn,
  required String text,
  bool isUpperCase= true,
  double radius=20.0,}) => Container(
  width: width,
  height: height,
  child: MaterialButton(
    
    onPressed: fn,
    child: Text(isUpperCase ? text.toUpperCase(): text,
      style: TextStyle(
        color: colortxt,
      ),),
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: color,
  ),
);

Widget DefaultFormField({
  required TextEditingController emailcontroller,
  required TextInputType textType ,
  required Icon icon,
  var submitted,
  var changed,
  var ontap,
  required validator,
  required String labelText,
  bool  obscure = false ,
  dynamic sufpressed,
  Icon? iconsuf,})=> TextFormField(

  controller: emailcontroller,
  keyboardType: textType, // yhadd naw3 l clavier li yokhrj
  obscureText: obscure,
  decoration: InputDecoration(
    labelText: labelText, // kyn hint text
    prefixIcon: icon,  //icon li mn l godam
    border: OutlineInputBorder(),
    suffixIcon: iconsuf != null ? IconButton(onPressed: sufpressed, icon: iconsuf) : null,
  ),
  onFieldSubmitted:submitted, // ba3d ma dakhli l value w tkliki done
  onTap: ontap,
  onChanged: changed,// hadi w ana nktb  byn results mich hata ndir done
  validator: validator,

);

Widget BuildTaskItem(Map model, context) =>  Dismissible(
    key: Key(model['id'].toString()),
    child:  Padding(
      padding:const EdgeInsets.all(20.0),
      child: Row(
        children:  [
          CircleAvatar(
            radius: 40.0,
            child: Text('${model['time']}'),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:  [
                  Text('${model['title']} ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),),
                  Text('${model['data']} ',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),),
                ],
              )),
          const SizedBox(
            width: 20.0,
          ),
          IconButton(
            onPressed: (){
              AppCubit.get(context).UpdateDatabase(status: 'done', id: model['id']);
            },
            color: Colors.green,
            icon: Icon(Icons.check_circle),),
          IconButton(
            onPressed: (){
              AppCubit.get(context).UpdateDatabase(status: 'archive', id: model['id']);
            },
            color: Colors.grey,
            icon: Icon(Icons.archive),),

        ],
      ),
    ),
  onDismissed: (direction)
  {
    AppCubit.get(context).DeletefromDatabase(id: model['id']);
  },
);


Widget TasksBuilder({required List<Map> tasks})=>ConditionalBuilder(
    condition: tasks.length>0,
    builder: (context)=>ListView.separated(
      itemBuilder: (context, index)=> BuildTaskItem(tasks[index],context),
      separatorBuilder: (context, index)=>  Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey,
      ),
      itemCount: tasks.length,),
    fallback: (context)=> Center(
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.menu),
          Text('NO TASKS YET, PLEASE ADD SOME TASKS'),
        ],
      ),));



Widget BuildArticleItem(article, context)=>Padding(padding:EdgeInsets.all(20.0) ,
  child: Row(
    children: [
      Container(
        height: 120.0,
        width: 120.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image:  DecorationImage(
            image: NetworkImage('${article['urlToImage']}'),
            fit: BoxFit.cover,
          ),

        ),
      ),
      const SizedBox(
        width: 20.0,),
      Expanded(
          child: Container(
            height: 120.0,
            child: Column(
              mainAxisAlignment:MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Expanded(
                    child: Text('${article['title']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600

                      ),
                    ),
                ),
                Text('${article['publishedAt']}',
                  style:Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
          )),
    ],
  ),);

Widget ArticleBuilder(list, context)=>ConditionalBuilder(
    condition:list.length>0,
    builder: (context)=>ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index)=>BuildArticleItem(list[index],context),
        separatorBuilder: (context, index)=>Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey,
        ),
        itemCount: 10),
    fallback: (context)=>Center(child: CircularProgressIndicator(),));










