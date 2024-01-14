import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_mobile_programming/task/model/todo.dart';
import 'package:to_do_mobile_programming/todo_database.dart';
import 'todo_add.dart';
import 'todo_detail.dart';
import 'weather_panel.dart';
import 'notification.dart';
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
    notificationManager.initialize();
    getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo List"),
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
            child: const Icon(Icons.add),
            tooltip: "Yeni Bir Task",
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeatherPanel()),
              );
            },
            child: const Icon(Icons.wb_sunny),
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
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                selectedDay = selectedDay.subtract(Duration(days: 1));
                getTodos();
              });
            },
          ),
          Text(
            DateFormat('yyyy-MM-dd').format(selectedDay),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              setState(() {
                selectedDay = selectedDay.add(Duration(days: 1));
                getTodos();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
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
          ? const Center(child: Text("Bu tarihe ait bir görev yok."))
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
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(todo.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(todo.description),
            const SizedBox(height: 4.0),
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
    });   checkUncompletedTasksForNotification();
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
                leading: const Icon(Icons.arrow_upward),
                title: const Text('Öncelik Sırasına Göre Sırala'),
                onTap: () {
                  sortTodosByPriority();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Zamana Göre Sırala'),
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
    final List<String> parts = time.split(":");
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1].replaceAll(RegExp('[^0-9]'), ''));


    if (time.toLowerCase().contains('pm') && hours < 12) {
      hours += 12;
    } else if (time.toLowerCase().contains('am') && hours == 12) {
      hours = 0;
    }

    return DateTime(0, 1, 1, hours, minutes);
  }
  void checkUncompletedTasksForNotification() async {
    try {
      final uncompletedTasks = todos.where((todo) => !todo.complete && !todo.isPast()).toList();

      for (var todo in uncompletedTasks) {
        await notificationManager.showNotification(todo);
      }
    } catch (e) {
      print("Error in checkUncompletedTasksForNotification: $e");
    }
  }
}
