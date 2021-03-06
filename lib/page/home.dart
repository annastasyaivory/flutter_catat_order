//import file pages lain untuk dipanggil
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catat_order/page/first_screen.dart';
import 'package:flutter_catat_order/page/navigation_drawer_widget.dart';
import 'package:flutter_catat_order/page/second_screen.dart';

class Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Shop Manager'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: Carousel(
              dotSize: 4,
              dotSpacing: 15,
              dotBgColor: Colors.transparent,
              dotVerticalPadding: 1,
              dotPosition: DotPosition.bottomCenter,
              images: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'img/slider1.png',
                    fit: BoxFit.cover,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'img/slider2.png',
                    fit: BoxFit.cover,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'img/slider3.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                margin: EdgeInsets.all(10),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Color.fromRGBO(0, 0, 0, 1))),
                  child: Column(
                    children: [
                      new Icon(
                        Icons.shopping_bag,
                        size: 100.0,
                        color: Colors.black,
                      ),
                      Text("Products",
                          style: TextStyle(
                              fontSize: 27, color: Color.fromRGBO(0, 0, 0, 1))),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SecondScreen()), //panggil fungsi dari file customer.dart untuk menampilkan listview isi tabel
                    );
                  },
                ),
              ),
              Container(
                height: 150,
                margin: EdgeInsets.all(10),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Color.fromRGBO(0, 0, 0, 1))),
                  child: Column(
                    children: [
                      new Icon(
                        Icons.people,
                        size: 100.0,
                        color: Colors.black,
                      ),
                      Text("Orders",
                          style: TextStyle(
                              fontSize: 27, color: Color.fromRGBO(0, 0, 0, 1))),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FirstScreen()), //panggil fungsi dari file transaksi.dart untuk menampilkan listview isi tabel
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
