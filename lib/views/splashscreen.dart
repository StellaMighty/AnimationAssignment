import 'package:AnimationAssignment/views/HomePage.dart';
import 'package:AnimationAssignment/views/login.dart';
import 'package:AnimationAssignment/views/register_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future checkAppOpened() async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    final opened = perf.getBool("Appopened");
    if (opened == true) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return MyHomePage();
      }));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return MyHomePage();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    checkAppOpened();
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            "assets/shoes/wallpaper.jpg",
          ),
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Welcome to",
              style: TextStyle(fontSize: 28, color: Colors.deepOrange),
            ),
            Text(
              "LEGGZ",
              style: TextStyle(fontSize: 40, color: Colors.deepOrange),
            ),
          ],
        ),
      ),
    );
  }
}
