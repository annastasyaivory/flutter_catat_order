import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catat_order/form/addProduct.dart';
import 'package:flutter_catat_order/auth/login_page.dart';
import 'package:flutter_catat_order/auth/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_catat_order/form/editProduct.dart';
import 'package:flutter_catat_order/page/navigation_drawer_widget.dart';

class SecondScreen extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text('Products'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new AddProduct(
                    email: auth.currentUser.email,
                  )));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(0),
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
      ]),
    );
  }
}

class ProductList extends StatelessWidget {
  ProductList({this.document});
  final List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: new ListView.builder(
        itemCount: document.length,
        itemBuilder: (BuildContext context, int i) {
          String nama = document[i].data()['nama'].toString();
          String harga = document[i].data()['harga'].toString();

          return Card(
            color: Colors.blueGrey,
            elevation: 2.0,
            shadowColor: Colors.black,
            child: new Dismissible(
              key: new Key(document[i].id),
              onDismissed: (direction) {
                FirebaseFirestore.instance
                    .runTransaction((Transaction transaction) async {
                  DocumentSnapshot snapshot =
                      await transaction.get(document[i].reference);
                  await transaction.delete(snapshot.reference);
                });
                Scaffold.of(context).showSnackBar(
                    new SnackBar(content: new Text("Data Deleted")));
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
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.attach_money,
                                    color: Colors.blueGrey[900],
                                  ),
                                ),
                                Text(
                                  harga,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
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
            ),
          );
        },
      ),
    );
  }
}
