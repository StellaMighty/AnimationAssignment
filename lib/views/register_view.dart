import 'package:AnimationAssignment/services/auth_servise.dart';
import 'package:AnimationAssignment/views/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Registerview extends StatefulWidget {
  @override
  _RegisterviewState createState() => _RegisterviewState();
}

class _RegisterviewState extends State<Registerview> {
  AuthService _authService = AuthService();

  final _formkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool registrationError = false;

  bool _obscureText = true;
  String _password;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Customer _customer = Provider.of<Customer>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: (registrationError == true)
                  ? Text("Please Register !",
                      style: TextStyle(color: Colors.red))
                  : Text("          ")),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please Enter Your Email Address";
                        } else {
                          return null;
                        }
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: "email",
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.blue.shade200,
                          )),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please Enter Your Full Name";
                        } else {
                          return null;
                        }
                      },
                      controller: fullNameController,
                      decoration: InputDecoration(
                          hintText: "Fullname",
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            color: Colors.blue.shade200,
                          )),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please Enter Your Password";
                        } else {
                          return null;
                        }
                      },
                      obscureText: _obscureText,
                      obscuringCharacter: "*",
                      controller: passwordController,
                      decoration: InputDecoration(
                          hintText: "Password",
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.visibility_off,
                                size: 15,
                              ),
                              onPressed: () {
                                _toggle();
                              }),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue.shade200,
                          )),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty || value != passwordController.text) {
                          return "Password did not match !";
                        } else {
                          return null;
                        }
                      },
                      controller: confirmPasswordController,
                      obscureText: _obscureText,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                          hintText: "Confirm Password",
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.visibility_off,
                                size: 15,
                              ),
                              onPressed: () {
                                _toggle();
                              }),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue.shade200,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        //  mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            onPressed: () async {
                              if (_formkey.currentState.validate()) {
                                String email = emailController.text;
                                String fullName = fullNameController.text;
                                String password = passwordController.text;

                                var result = await _authService.registerUser(
                                    email: email, password: password);

                                print(result);
                                if (result == null) {
                                  setState(() {
                                    registrationError = true;
                                  });
                                } else {
                                  String uid = result.uid;
                                  final FirebaseFirestore _firestore =
                                      FirebaseFirestore.instance;
                                  final CollectionReference _customerCol =
                                      _firestore.collection("customers");
                                  DocumentReference _customerDoc =
                                      _customerCol.doc(uid);
                                  _customerDoc.set({"fullname": fullName});
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  await pref
                                      .setBool('appOpened', true)
                                      .whenComplete(() =>
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return MyHomePage();
                                          })));
                                }
                              }
                            },
                            child: Text("REGISTER"),
                            color: Colors.orange.shade300,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
