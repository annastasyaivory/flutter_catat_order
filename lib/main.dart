import 'package:flutter/material.dart';
import 'package:flutter_catat_order/splashscreen_view.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreenPage(),
    );
    // return Scaffold(
    //   body: Container(
    //       color: Colors.yellow,
    //       child: Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           mainAxisSize: MainAxisSize.max,
    //           children: <Widget>[
    //             Container(
    //               color: Colors.white12,
    //             ),
    //             FlatButton(
    //               onPressed: () {
    //                 Navigator.push(
    //                   context,
    //                   MaterialPageRoute(builder: (context) => LoginPage()),
    //                 );
    //               },
    //               child: Text(
    //                 "Get Started !",
    //               ),
    //             )
    //           ],
    //         ),
    //       )),
    // );
  }
}
