import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:to_do_mobile_programming/Task/model/todo.dart';
import 'package:to_do_mobile_programming/database_helper.dart';

// class TodoAdd extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return TodoAddState();
//   }
// }
//
// class TodoAddState extends State {
//   var dbHelper=DatabaseHelper();
//   var txtName=TextEditingController();
//   var txtDescription=TextEditingController();
//   var txtDate=TextEditingController();
//   var txtPriority=TextEditingController();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("EKleme"),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(35),
//         child: Column(
//           children: <Widget>[
//             buildNameField(),
//             buildDescriptionField(),
//             buildDateField(),
//             builPriorityField(),
//             buildSaveButton(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   buildNameField() {
//     return TextField(
//       decoration: InputDecoration(labelText: "isim"),
//       controller:txtName ,
//     );
//   }
//
//   buildDescriptionField() { return TextField(
//     decoration: InputDecoration(labelText: "detay"),
//     controller:txtDescription ,
//   );}
//
//   buildDateField() { return TextField(
//     decoration: InputDecoration(labelText: "tarihh"),
//     controller:txtDate ,
//   );}
//
//   builPriorityField() { return TextField(
//     decoration: InputDecoration(labelText: "öncelik sırası"),
//     controller:txtPriority ,
//   );}
//
//   buildSaveButton() {
//     return FloatingActionButton(
//       child: Icon(Icons.add),
//         tooltip: "Ekle",
//
//         onPressed: (){
//       addTodo();
//
//     }
//     );
//
//   }
//



class TodoAdd extends StatefulWidget {

  // Passing function as parameter

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TodoAddState();
  }
}

class TodoAddState extends State {
  var dbHelper=DatabaseHelper();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var txtPriority=TextEditingController();




  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(

        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: deviceWidth,
                height: deviceHeight / 10,
                decoration: const BoxDecoration(
                  color: Colors.purple,

                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        "Add new task",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 21),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 10), child: Text("Task title")),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),


              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text("Description"),
              ),
              SizedBox(
                height: 300,
                child: TextField(
                  controller: descriptionController,
                  expands: true,
                  maxLines: null,
                  decoration: const InputDecoration(
                      filled: true, fillColor: Colors.white, isDense: true),
                ),
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 10), child: Text("priority")),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: txtPriority,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text("Date"),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              controller: dateController,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              ),


              ElevatedButton(


                  onPressed: () {

                    addTodo();
                  },
                  child: const Text("Save"))
            ],
          ),
        ),
      ),
    );
  }
  void addTodo() async {
    var result= await dbHelper.insertTodo(Todo(title: titleController.text,description: descriptionController.text,date :dateController.text,priority:txtPriority.text));
    Navigator.pop(context,true);
  }

}
var titleController = TextEditingController();
var descriptionController = TextEditingController();
var dateController = TextEditingController();
var timeController = TextEditingController();
var txtPriority=TextEditingController();
