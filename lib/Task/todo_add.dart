import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_mobile_programming/task/model/todo.dart';
import 'package:to_do_mobile_programming/todo_database.dart';

class TodoAdd extends StatefulWidget {
  @override
  _TodoAddState createState() => _TodoAddState();
}

class _TodoAddState extends State<TodoAdd> {
  late DatabaseHelper dbHelper;

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  late DateTime selectedDate = DateTime.now();
  late TimeOfDay selectedTime = TimeOfDay.now();
  int selectedPriority = 1;

  Widget buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      decoration: InputDecoration(labelText: labelText),
      controller: controller,
    );
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni görev ekleme"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildTextField("Başlık", titleController),
            buildTextField("Açıklama", descriptionController),
            buildDateField(),
            buildTimeField(),
            buildPriorityDropdown(),
            ElevatedButton(
              onPressed: () async {
                await addTodo();
                Navigator.pop(context, true);
              },
              child: const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDateField() {
    return GestureDetector(
      onTap: () async {
        var pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null) {
          setState(() {
            selectedDate = pickedDate;
          });
        }
      },
      child: AbsorbPointer(
        child: buildTextField(
          "Tarih",
          TextEditingController(
            text: DateFormat('yyyy-MM-dd').format(selectedDate),
          ),
        ),
      ),
    );
  }

  Widget buildTimeField() {
    return GestureDetector(
      onTap: () async {
        var pickedTime = await showTimePicker(
          context: context,
          initialTime: selectedTime,
        );

        if (pickedTime != null) {
          setState(() {
            selectedTime = pickedTime;
          });
        }
      },
      child: AbsorbPointer(
        child: buildTextField(
          "Saat",
          TextEditingController(
            text: selectedTime.format(context),
          ),
        ),
      ),
    );
  }

  Widget buildPriorityDropdown() {
    return DropdownButtonFormField<int>(
      value: selectedPriority,
      onChanged: (value) {
        setState(() {
          selectedPriority = value!;
        });
      },
      items: [
        const DropdownMenuItem(
          value: 1,
          child:  Text("Yüksek"),
        ),
        const DropdownMenuItem(
          value: 2,
          child:  Text("Orta"),
        ),
        const DropdownMenuItem(
          value: 3,
          child: Text("Düşük"),
        ),
      ],
      decoration: const InputDecoration(labelText: "Öncelik"),
    );
  }

  Future<void> addTodo() async {
    var title = titleController.text.trim();
    var description = descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      _showSnackBar(context, 'Please fill in all fields');
      return;
    }

    var priority = selectedPriority;

    var todo = Todo(
      userId: "defaultUser",
      title: title,
      description: description,
      date: DateFormat('yyyy-MM-dd').format(selectedDate),
      time: selectedTime.format(context),
      priority: priority,
    );

    await dbHelper.insertTodo(todo);
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
