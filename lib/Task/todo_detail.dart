import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_mobile_programming/Task/model/todo.dart';
import 'package:to_do_mobile_programming/database_helper.dart';

class TodoDetail extends StatefulWidget{
  Todo todo;
  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() {

    return TodoDetailState(todo);
  }


}
enum options{ delete, update}
class TodoDetailState  extends State{
  var dbHelper = DatabaseHelper();

  var txtName=TextEditingController();
   var txtDescription=TextEditingController();
   var txtDate=TextEditingController();
   var txtPriority=TextEditingController();
  late Todo todo;
  TodoDetailState(this.todo);

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detay"),
        actions: <Widget>[
          PopupMenuButton<options>(
            onSelected: selectProcess,
            itemBuilder: (BuildContext context)=><PopupMenuEntry<options>>[
              PopupMenuItem(
                value: options.delete,
                child: Text("sil"),
              ),
              PopupMenuItem(
                value: options.update,
                child: Text("güncelle"),
              )
            ],

          )
        ],


      ),
      body: buildTodoDetail(),
    );
  }
  buildTodoDetail(){
    return Padding(
         padding: EdgeInsets.all(35),
         child: Column(
          children: <Widget>[
             buildNameField(),
             buildDescriptionField(),
             buildDateField(),
             builPriorityField(),

           ],
        ),
    );


  }
  buildNameField() {
     return TextField(
       decoration: InputDecoration(labelText: "isim"),
       controller:txtName ,
     );
   }

   buildDescriptionField() { return TextField(
    decoration: InputDecoration(labelText: "detay"),
     controller:txtDescription ,
   );}

  buildDateField() { return TextField(
     decoration: InputDecoration(labelText: "tarihh"),
     controller:txtDate ,
  );}

  builPriorityField() { return TextField(
     decoration: InputDecoration(labelText: "öncelik sırası"),
    controller:txtPriority ,
  );}


  void selectProcess(options value) async{
    switch(value){
      case options.delete:
        await dbHelper.deleteTodo(todo.id);
        Navigator.pop(context,true);
        break;
      case options.update:
        await dbHelper.updateTodo(Todo.withId(
            id:todo.id,
            title:txtName.text,
            priority:txtPriority.text,
            date:txtDate.text,
            description:txtDescription.text));
      default :


    }
  }
}