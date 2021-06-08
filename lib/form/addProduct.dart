import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProduct extends StatefulWidget {
  AddProduct({this.email});
  final String email;
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String nama = '';
  String harga = '';

  void _addProduct() {
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference =
          FirebaseFirestore.instance.collection('product');
      await reference.add({
        "email": widget.email,
        "nama": nama,
        "harga": harga,
      });
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Container(
            height: 115.0,
            width: double.infinity,
            decoration: BoxDecoration(boxShadow: [
              new BoxShadow(color: Colors.black, blurRadius: 8.0)
            ], color: Colors.yellow),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Order Manager",
                  style: TextStyle(fontSize: 30.0, letterSpacing: 2.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Add Product",
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              onChanged: (String str) {
                setState(() {
                  nama = str;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.person_pin),
                hintText: "Nama Produk",
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 22.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              onChanged: (String str) {
                setState(() {
                  harga = str;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.phone),
                hintText: "Harga",
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 22.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 30.0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                IconButton(
                    icon: Icon(
                      Icons.check,
                      size: 30.0,
                    ),
                    onPressed: () {
                      _addProduct();
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
