import 'package:flutter/material.dart';
import 'package:flutter_catat_order/page/splashscreen_view.dart';
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
      home:
          SplashScreenPage(), //memanggil splashscreen untuk ditampilkan pertama kali saat aplikasi dijalankan
    );
  }
}
