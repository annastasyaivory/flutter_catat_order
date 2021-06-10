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
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: controllerNama,
                onChanged: (String str) {
                  setState(() {
                    nama = str;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
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
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Colors.blueGrey[900],
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Cancel',
                        textScaleFactor: 1.5,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Colors.blueGrey[900],
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Save',
                        textScaleFactor: 1.5,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _updateProduct();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
