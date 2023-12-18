import 'package:flutter/material.dart';
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
        title: Text('Giriş Yap'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Giriş',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final enteredEmail = emailController.text;
                  final enteredPassword = passwordController.text;

                  try {
                    final dbHelper = DatabaseHelper();
                    final isValidUser = await dbHelper.checkUserCredentials(enteredEmail, enteredPassword);

                    if (isValidUser) {

                      errorMessage = '';
                    } else {
                      
                      errorMessage = 'E-posta veya şifre hatalı';
                    }

                  } catch (e) {
                    errorMessage = 'Veritabanı hatası: $e';
                  }


                  (context as Element).markNeedsBuild();
                },
                child: Text('Giriş Yap'),
              ),
              SizedBox(height: 8),
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ),
                  );
                },
                child: Text('Hesabınız yoksa kaydolun'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
