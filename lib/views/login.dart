import 'package:AnimationAssignment/views/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:AnimationAssignment/services/auth_servise.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: ListView(
          children: [
            Text(
              "Enter your login details",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: "Enter your email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(hintText: "Enter your password"),
            ),
            FlatButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    String email = emailController.text;
                    String password = passwordController.text;
                    var result = await _authService.loginCustomer(
                        email: email, password: password);
                  } else {}

                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return MyHomePage();
                  }));
                },
                child: Text("Log in"))
          ],
        ),
      ),
    );
  }
}
