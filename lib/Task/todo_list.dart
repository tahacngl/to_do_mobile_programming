import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:to_do_mobile_programming/Task/todo_add.dart';
import 'package:to_do_mobile_programming/Task/todo_detail.dart';
import 'package:to_do_mobile_programming/database_helper.dart';

import 'model/todo.dart';

class TodoList extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return _TodoListDtate();
  }
}

class _TodoListDtate  extends State {
  var dbHelper = DatabaseHelper();
  late List<Todo> todos;
  int todoCount = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo List"),
      ),
      body: buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed:() {
          goToTaskAdd();

        },
        child: Icon(Icons.add),
        tooltip: "Yeni Bir Task",

      ),

    );
  }

  ListView buildTodoList() {
    return ListView.builder(
        itemCount: todoCount,
        itemBuilder: (BuildContext context, int position) => Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getColor(this.todos[position].priority),
                child: Text(
                  this.todos[position].id.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(this.todos[position].title),
              subtitle: Text(this.todos[position].description),
              onTap: () {
                goToDetail(this.todos[position]);

              },
            )));
  }


  @override
  void initState(){
    final todosFuture = dbHelper.getTodos();
    todosFuture.then((value){
      this.todos=value;
    });


  }


  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      default:
        return Colors.green;
    }
  }

  void goToTaskAdd() async {
   bool result= await Navigator.push(context, MaterialPageRoute(builder: (context)=>TodoAdd()));
    if(result!=null){
      if(result){
        getTodo();

      }
    }


  }
  void getTodo(){
    final todosFuture = dbHelper.getTodos();
    todosFuture.then((value){
      this.todos=value;
    });

  }

  void goToDetail(Todo todo) async {
    bool result= await Navigator.push(context, MaterialPageRoute(builder: (context)=>TodoDetail(todo)));
    if(result!=null){
      if(result){
        getTodo();
      }
    }
  }
}