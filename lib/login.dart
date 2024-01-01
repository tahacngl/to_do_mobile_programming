import 'package:flutter/material.dart';
import 'Task/todo_list.dart';
import 'register.dart';
import 'database_helper.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String errorMessage;

  LoginScreen() {
    errorMessage = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("ToDo List")),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Giriş',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final enteredEmail = emailController.text;
                  final enteredPassword = passwordController.text;

                  try {
                    final dbHelper = DatabaseHelper();
                    final isValidUser = await dbHelper.checkUserCredentials(enteredEmail, enteredPassword);

                    if (isValidUser) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => TodoList()));
                    } else {
                      errorMessage = 'E-posta veya şifre hatalı';
                    }
                  } catch (e) {
                    errorMessage = 'Veritabanı hatası: $e';
                  }

                  (context as Element).markNeedsBuild();
                },
                child: const Text('Giriş Yap'),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ),
                  );
                },
                child: const Text('Hesabınız yoksa kaydolun'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
