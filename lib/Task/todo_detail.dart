import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_mobile_programming/task/model/todo.dart';
import 'package:to_do_mobile_programming/todo_database.dart';

class TodoDetail extends StatefulWidget {
  Todo todo;
  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() {
    return TodoDetailState(todo);
  }
}

enum Options { delete, update, complete }

class TodoDetailState extends State<TodoDetail> {
  var dbHelper = DatabaseHelper();

  var txtName = TextEditingController();
  var txtDescription = TextEditingController();
  var txtDate = TextEditingController();
  var txtPriority = TextEditingController();
  var txtTime = TextEditingController();
  late Todo todo;
  bool completed = false;

  TodoDetailState(this.todo);

  @override
  void initState() {
    super.initState();
    txtName.text = todo.title;
    txtDescription.text = todo.description;
    txtDate.text = todo.date;
    txtTime.text = todo.time ?? "";
    txtPriority.text = getPriorityText(todo.priority);
    completed = todo.complete;
  }

  Future<void> _showUpdateDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Görevi Güncelle'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: txtName,
                  decoration: const InputDecoration(labelText: 'Başlık'),
                ),
                TextField(
                  controller: txtDescription,
                  decoration: const InputDecoration(labelText: 'Açıklama'),
                ),
                GestureDetector(
                  onTap: () async {
                    var pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        txtDate.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: buildTextField(
                      "Tarih",
                      TextEditingController(
                        text: txtDate.text,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      setState(() {
                        txtTime.text = pickedTime.format(context);
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: buildTextField(
                      "Saat",
                      TextEditingController(
                        text: txtTime.text,
                      ),
                    ),
                  ),
                ),
                DropdownButtonFormField<int>(
                  value: todo.priority,
                  onChanged: (value) {
                    setState(() {
                      todo.priority = value!;
                      txtPriority.text = getPriorityText(value);
                    });
                  },
                  items: [
                    const DropdownMenuItem(
                      value: 1,
                      child:  Text("Yuksek"),
                    ),
                    const DropdownMenuItem(
                      value: 2,
                      child:  Text("Orta"),
                    ),
                    const DropdownMenuItem(
                      value: 3,
                      child:  Text("Dusuk"),
                    ),
                  ],
                  decoration: const InputDecoration(labelText: "Oncelik"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                updateTodo();
                Navigator.of(context).pop();
              },
              child: const Text('Güncelle'),
            ),
          ],
        );
      },
    );
  }

  void updateTodo() async {
    var title = txtName.text.trim();
    var description = txtDescription.text.trim();

    if (title.isEmpty || description.isEmpty) {
      _showSnackBar(context, 'Lütfen tüm alanları doldurun');
      return;
    }

    var priority = todo.priority;
    var currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

    var updatedTodo = Todo(
      id: todo.id,
      userId: "defaultUser",
      title: title,
      description: description,
      date: txtDate.text,
      time: txtTime.text.isNotEmpty ? txtTime.text : currentTime,
      priority: priority,
      complete: completed,
    );

    await dbHelper.updateTodo(updatedTodo);
    setState(() {
      completed = !completed;
    });
    Navigator.pop(context, true);
  }

  String getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return "Yüksek";
      case 2:
        return "Orta";
      case 3:
        return "Düşük";
      default:
        return "";
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detay"),
        actions: <Widget>[
          PopupMenuButton<Options>(
            onSelected: selectProcess,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
              const PopupMenuItem(
                value: Options.delete,
                child:  Text("Sil"),
              ),
              const PopupMenuItem(
                value: Options.update,
                child:  Text("Güncelle"),
              ),
              const PopupMenuItem(
                value: Options.complete,
                child: Text("Tamamlandı"),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Başlık: ${todo.title}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Açıklama: ${todo.description}"),
            const SizedBox(height: 8),
            Text("Tarih: ${todo.date}"),
            const SizedBox(height: 8),
            Text("Saat: ${txtTime.text}"),
            const SizedBox(height: 8),
            Text("Öncelik: ${getPriorityText(todo.priority)}"),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  completed = !completed;
                  updateTodo();
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: completed ? Colors.grey : Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      completed ? Icons.check : Icons.check_box_outline_blank,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Tamamlandı",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void selectProcess(Options value) async {
    switch (value) {
      case Options.delete:
        await dbHelper.deleteTodo(todo.id);
        Navigator.pop(context, true);
        break;
      case Options.update:
        _showUpdateDialog();
        break;
      case Options.complete:
        setState(() {
          completed = !completed;
          updateTodo();
        });
        break;
    }
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      decoration: InputDecoration(labelText: labelText),
      controller: controller,
    );
  }
}
