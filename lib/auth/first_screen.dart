import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catat_order/addOrder.dart';
import 'package:flutter_catat_order/auth/login_page.dart';
import 'package:flutter_catat_order/auth/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirstScreen extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new AddOrder(
                    email: auth.currentUser.email,
                  )));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.yellow,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: new BottomAppBar(
        elevation: 20.0,
        color: Colors.yellow,
        child: ButtonBar(
          children: <Widget>[],
        ),
      ),
      body: Stack(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 110.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("order")
                .where("email", isEqualTo: auth.currentUser.email)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return new Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              return new OrderList(
                document: snapshot.data.docs,
              );
            },
          ),
        ),
        Container(
          height: 115.0,
          width: double.infinity,
          decoration: BoxDecoration(
              boxShadow: [new BoxShadow(color: Colors.black, blurRadius: 8.0)],
              color: Colors.yellow),
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: new AssetImage("img/logo.png"),
                          fit: BoxFit.cover)),
                ),
                Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Order Manager",
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.black),
                        ),
                        new Text(
                          auth.currentUser.email,
                          style: new TextStyle(
                              fontSize: 16.0, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                new IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  onPressed: () {
                    if (imageUrl != null) {
                      signOutGoogle();
                    } else {
                      Navigator.of(context).pop();
                    }

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                      return LoginPage();
                    }), ModalRoute.withName('/'));
                  },
                )
              ],
            ),
          ),
        ),
      ]),
      // body: Container(
      //   color: Colors.white,
      //   child: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       mainAxisSize: MainAxisSize.max,
      //       children: <Widget>[
      //         // CircleAvatar(
      //         //   //menampilkan foto dari akun google
      //         //   backgroundImage: NetworkImage(
      //         //     imageUrl,
      //         //   ),
      //         //   radius: 60,
      //         //   backgroundColor: Colors.transparent,
      //         // ),
      //         // SizedBox(height: 40),
      //         // Text(
      //         //   'NAME',
      //         //   style: TextStyle(
      //         //       fontSize: 15,
      //         //       fontWeight: FontWeight.bold,
      //         //       color: Colors.black54),
      //         // ),
      //         // Text(
      //         //   //menampilkan nama dari akun email
      //         //   auth.currentUser.displayName,
      //         //   style: TextStyle(
      //         //       fontSize: 25,
      //         //       color: Colors.black,
      //         //       fontWeight: FontWeight.bold),
      //         // ),
      //         // SizedBox(height: 20),
      //         Text(
      //           'EMAIL',
      //           style: TextStyle(
      //               fontSize: 15,
      //               fontWeight: FontWeight.bold,
      //               color: Colors.black54),
      //         ),
      //         Text(
      //           auth.currentUser.email, //menampilkan email
      //           style: TextStyle(
      //               fontSize: 25,
      //               color: Colors.black,
      //               fontWeight: FontWeight.bold),
      //         ),
      //         SizedBox(height: 40),
      //         RaisedButton(
      //           onPressed: () {
      //             if (imageUrl != null) {
      //               signOutGoogle();
      //             } else {
      //               Navigator.of(context).pop();
      //             }

      //             Navigator.of(context).pushAndRemoveUntil(
      //                 MaterialPageRoute(builder: (context) {
      //               return LoginPage();
      //             }), ModalRoute.withName('/'));
      //           },
      //           color: Colors.yellow,
      //           child: Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: Text(
      //               'Sign Out',
      //               style: TextStyle(fontSize: 25, color: Colors.black),
      //             ),
      //           ),
      //           elevation: 5,
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}

class OrderList extends StatelessWidget {
  OrderList({this.document});
  final List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String name = document[i].data()['name'].toString();
        String date = document[i].data()['date'].toString();
        String phone = document[i].data()['phone'].toString();

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        name,
                        style: TextStyle(fontSize: 20.0, letterSpacing: 1.0),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.date_range,
                            color: Colors.pink,
                          ),
                        ),
                        Text(
                          date,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.phone,
                            color: Colors.pink,
                          ),
                        ),
                        Text(
                          phone,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}