import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catat_order/form/addProduct.dart';
import 'package:flutter_catat_order/auth/login_page.dart';
import 'package:flutter_catat_order/auth/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_catat_order/form/editProduct.dart';

class SecondScreen extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new AddProduct(
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
                .collection("product")
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
              return new ProductList(
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
    );
  }
}

class ProductList extends StatelessWidget {
  ProductList({this.document});
  final List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String nama = document[i].data()['nama'].toString();
        String harga = document[i].data()['harga'].toString();

        return new Dismissible(
          key: new Key(document[i].id),
          onDismissed: (direction) {
            FirebaseFirestore.instance
                .runTransaction((Transaction transaction) async {
              DocumentSnapshot snapshot =
                  await transaction.get(document[i].reference);
              await transaction.delete(snapshot.reference);
            });
            Scaffold.of(context)
                .showSnackBar(new SnackBar(content: new Text("Data Deleted")));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            nama,
                            style:
                                TextStyle(fontSize: 20.0, letterSpacing: 1.0),
                          ),
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
                              harga,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new EditProduct(
                              nama: nama,
                              harga: harga,
                              index: document[i].reference,
                            )));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
