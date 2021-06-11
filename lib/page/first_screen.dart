import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catat_order/form/addOrder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_catat_order/form/editOrder.dart';
import 'package:flutter_catat_order/page/navigation_drawer_widget.dart';

class FirstScreen extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text('Orders'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      //button untuk add data baru
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new AddOrder(
                    email: auth.currentUser.email, //dengan mengirimkan email
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
            //menampilkan data sesuai user yang sedang login
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
      ]),
    );
  }
}

class OrderList extends StatelessWidget {
  OrderList({this.document});
  final List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: new ListView.builder(
        itemCount: document.length,
        itemBuilder: (BuildContext context, int i) {
          String name = document[i].data()['name'].toString();
          DateTime _date = document[i].data()['date'].toDate();
          String phone = document[i].data()['phone'].toString();
          String date = "${_date.day}/${_date.month}/${_date.year}";
          String alamat = document[i].data()['alamat'].toString();
          String total = document[i].data()['total'].toString();
          String status = document[i].data()['status'].toString();
          String product = document[i].data()['product'].toString();

          return Card(
            color: Colors.blueGrey,
            elevation: 2.0,
            shadowColor: Colors.black,
            //swipe to delete data
            child: new Dismissible(
              key: new Key(document[i].id),
              onDismissed: (direction) {
                FirebaseFirestore.instance
                    .runTransaction((Transaction transaction) async {
                  //document snapshot membaca dokumen di firebase
                  DocumentSnapshot snapshot =
                      await transaction.get(document[i].reference);
                  await transaction.delete(snapshot.reference);
                });
                //snack bar tampil di bawah jika ada data yang terhapus
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
                                name,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    letterSpacing: 1.0,
                                    color: Colors.white),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Icon(
                                    Icons.date_range,
                                    color: Colors.blueGrey[900],
                                  ),
                                ),
                                Text(
                                  date,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Icon(
                                    Icons.phone,
                                    color: Colors.blueGrey[900],
                                  ),
                                ),
                                Text(
                                  phone,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Icon(
                                    Icons.home_rounded,
                                    color: Colors.blueGrey[900],
                                  ),
                                ),
                                Text(
                                  alamat,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Icon(
                                    Icons.shopping_basket,
                                    color: Colors.blueGrey[900],
                                  ),
                                ),
                                Text(
                                  product,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Icon(
                                    Icons.money,
                                    color: Colors.blueGrey[900],
                                  ),
                                ),
                                Text(
                                  total,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Icon(
                                    Icons.info,
                                    color: Colors.blueGrey[900],
                                  ),
                                ),
                                Text(
                                  status,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //edit data
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            //mengirimkan parameter
                            builder: (BuildContext context) => new EditOrder(
                                  name: name,
                                  date: document[i].data()['date'].toDate(),
                                  phone: phone,
                                  alamat: alamat,
                                  product: product,
                                  total: total,
                                  status: status,
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
