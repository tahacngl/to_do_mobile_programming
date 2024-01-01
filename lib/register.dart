import 'package:flutter/material.dart';
import 'database_helper.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Kayıt Ol',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Ad Soyad',
              ),
            ),
            SizedBox(height: 8),
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
                final name = nameController.text;
                final email = emailController.text;
                final password = passwordController.text;

                if (name.isEmpty || email.isEmpty || password.isEmpty) {

                  errorMessage = 'Bütün alanları doldurunuz';
                } else {

                  final isEmailTaken = await dbHelper.checkEmailTaken(email);

                  if (isEmailTaken) {

                    errorMessage = 'Bu e-posta adresi zaten kullanılmış';
                  } else {

                    dbHelper.insertUser(name, email, password);

                    Navigator.pop(context);
                  }
                }


                (context as Element).markNeedsBuild();
              },
              child: Text('Kayıt Ol'),
            ),
            SizedBox(height: 8),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
