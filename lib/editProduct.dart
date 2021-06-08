import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProduct extends StatefulWidget {
  EditProduct({this.nama, this.harga, this.index});
  final String nama;
  final String harga;
  final index;
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  TextEditingController controllerNama;
  TextEditingController controllerHarga;

  String nama;
  String harga;

  void _updateProduct() {
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(widget.index);
      await transaction.update(snapshot.reference, {
        "nama": nama,
        "harga": harga,
      });
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    nama = widget.nama;
    harga = widget.harga;

    controllerNama = new TextEditingController(text: widget.nama);
    controllerHarga = new TextEditingController(text: widget.harga);
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
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Edit Product",
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: controllerNama,
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
              controller: controllerHarga,
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
                      Icons.check,
                      size: 30.0,
                    ),
                    onPressed: () {
                      _updateProduct();
                    }),
                IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 30.0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
