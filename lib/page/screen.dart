//import file pages lain untuk dipanggil
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catat_order/page/first_screen.dart';
import 'package:flutter_catat_order/page/second_screen.dart';

class Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Catatan Orderan'),
        backgroundColor: Colors.blueGrey[200],
      ),
      body: Container(
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
                      Icons.account_circle,
                      size: 100.0,
                      color: Colors.black,
                    ),
                    Text("Customer",
                        style: TextStyle(
                            fontSize: 27, color: Color.fromRGBO(0, 0, 0, 1))),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FirstScreen()), //panggil fungsi dari file customer.dart untuk menampilkan listview isi tabel
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
                      Icons.wallet_travel_rounded,
                      size: 100.0,
                      color: Colors.black,
                    ),
                    Text("Transaksi",
                        style: TextStyle(
                            fontSize: 27, color: Color.fromRGBO(0, 0, 0, 1))),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SecondScreen()), //panggil fungsi dari file transaksi.dart untuk menampilkan listview isi tabel
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
