import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_mobile_programming/task/model/todo.dart';
import 'package:to_do_mobile_programming/todo_database.dart';
import 'todo_add.dart';
import 'todo_detail.dart';
import 'weather_panel.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final dbHelper = DatabaseHelper();
  List<Todo> todos = [];
  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo List"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDateSelector(),
          Expanded(child: buildTodoList()),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              bool? result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TodoAdd()),
              );

              if (result != null && result) {
                getTodos();
              }
            },
            child: Icon(Icons.add),
            tooltip: "Yeni Bir Task",
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeatherPanel()),
              );
            },
            child: Icon(Icons.wb_sunny),
            tooltip: "Hava Durumu",
          ),
        ],
      ),
    );
  }

  Widget buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                selectedDay = selectedDay.subtract(Duration(days: 1));
                getTodos();
              });
            },
          ),
          Text(
            DateFormat('yyyy-MM-dd').format(selectedDay),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              setState(() {
                selectedDay = selectedDay.add(Duration(days: 1));
                getTodos();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              showSortOptions();
            },
          ),
        ],
      ),
    );
  }

  Widget buildTodoList() {
    List<Todo> selectedDayTodos = groupTodosByDate();

    return Container(
      color: Colors.grey[700],
      child: selectedDayTodos.isEmpty
          ? Center(child: Text("Bu tarihe ait bir görev yok."))
          : ListView.builder(
        itemCount: selectedDayTodos.length,
        itemBuilder: (BuildContext context, int index) {
          Todo todo = selectedDayTodos[index];
          return buildTodoCard(todo);
        },
      ),
    );
  }

  Widget buildTodoCard(Todo todo) {
    return Card(
      color: todo.complete ? Colors.grey : Colors.white,
      elevation: 2.0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: getColor(todo.priority),
          child: Text(
            todo.id.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(todo.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(todo.description),
            SizedBox(height: 4.0),
            Text('Date: ${todo.date}'),
            Text('Time: ${todo.time}'),
          ],
        ),
        onTap: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoDetail(todo)),
          );

          if (result != null && result) {
            getTodos();
          }
        },
      ),
    );
  }

  Future<void> getTodos() async {
    final fetchedTodos = await dbHelper.getTodosByEmail("defaultUser");
    setState(() {
      todos = fetchedTodos;
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

  List<Todo> groupTodosByDate() {
    return todos.where((todo) => todo.date == DateFormat('yyyy-MM-dd').format(selectedDay)).toList();
  }

  void sortTodosByPriority() {
    setState(() {
      todos.sort((a, b) => a.priority.compareTo(b.priority));
    });
  }

  void sortTodosByTime() {
    setState(() {
      todos.sort((a, b) => addAMPMToDateTime(a.time).compareTo(addAMPMToDateTime(b.time)));
    });
  }

  void showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.arrow_upward),
                title: Text('Öncelik Sırasına Göre Sırala'),
                onTap: () {
                  sortTodosByPriority();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text('Zamana Göre Sırala'),
                onTap: () {
                  sortTodosByTime();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  DateTime addAMPMToDateTime(String time) {
    final DateTime currentTime = DateTime.now();
    final List<String> parts = time.split(":");

    if (parts.length == 2) {
      final int hours = int.parse(parts[0]);
      final int minutes = int.parse(parts[1]);

      DateTime result = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        hours,
        minutes,
      );

      return result;
    } else {
      return currentTime;
    }
  }
}
