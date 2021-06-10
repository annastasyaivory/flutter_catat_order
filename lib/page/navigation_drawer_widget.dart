import 'package:flutter/material.dart';
import 'package:flutter_catat_order/auth/login_page.dart';
import 'package:flutter_catat_order/auth/sign_in.dart';
import 'package:flutter_catat_order/page/first_screen.dart';
import 'package:flutter_catat_order/page/home.dart';
import 'package:flutter_catat_order/page/second_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    final name = 'Shop Manager';
    final email = auth.currentUser.email;

    return Drawer(
      child: Material(
        color: Colors.blueGrey[900],
        child: ListView(
          children: <Widget>[
            Row(
              children: [
                SizedBox(
                  width: 7,
                ),
                Image.asset("img/logo.png", width: 60, height: 60),
                buildHeader(
                  name: name,
                  email: email,
                ),
              ],
            ),
            buildMenuItem(
              text: 'Home',
              icon: Icons.home,
              onClicked: () => selectedItem(context, 0),
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'Product',
              icon: Icons.shopping_bag,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'Orders',
              icon: Icons.people,
              onClicked: () => selectedItem(context, 2),
            ),
            Divider(color: Colors.white70),
            buildMenuItem(
                text: 'Sign Out',
                icon: Icons.exit_to_app,
                onClicked: () {
                  if (imageUrl != null) {
                    signOutGoogle();
                  } else {
                    Navigator.of(context).pop();
                  }
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }), ModalRoute.withName('/'));
                }),
            Divider(color: Colors.white70),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    String name,
    String email,
  }) =>
      InkWell(
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  )
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildMenuItem({
    String text,
    IconData icon,
    onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Screen()));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SecondScreen()));
        break;
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => FirstScreen()));
    }
  }
}
