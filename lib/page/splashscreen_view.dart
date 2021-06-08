import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_catat_order/auth/login_page.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 10);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return LoginPage();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow[200],
        body: Column(
          children: [
            SizedBox(height: 100),
            Center(
              child: Image.asset(
                "img/logo.png",
                width: 200.0,
                height: 200.0,
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.only(right: 30, left: 30),
              child: Text(
                'Shop Manager',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.only(right: 30, left: 30),
              child: Text(
                'Manage products and orders from your store so that they are properly recorded!',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ],
        ));
  }
}
