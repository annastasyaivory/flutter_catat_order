import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddOrder extends StatefulWidget {
  AddOrder({this.email});
  final String email;
  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  DateTime _dueDate = new DateTime.now();
  String _dateText = '';

  String name = '';
  String phone = '';

  Future<Null> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _dueDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2080));
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dateText = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _addData() {
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference =
          FirebaseFirestore.instance.collection('order');
      await reference.add({
        "email": widget.email,
        "name": name,
        "date": _dueDate,
        "phone": phone,
      });
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _dateText = "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";
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
                    "Add Order",
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
                Icon(
                  Icons.list,
                  color: Colors.black,
                  size: 30.0,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (String str) {
                setState(() {
                  name = str;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.person_pin),
                hintText: "Name",
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 22.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.date_range),
                ),
                Expanded(
                    child: Text(
                  "Date",
                  style: TextStyle(fontSize: 22.0, color: Colors.black54),
                )),
                FlatButton(
                    onPressed: () => _selectDueDate(context),
                    child: Text(
                      _dateText,
                      style: TextStyle(fontSize: 22.0, color: Colors.black54),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (String str) {
                setState(() {
                  phone = str;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.phone),
                hintText: "Phone Number",
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 22.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.check,
                      size: 40.0,
                    ),
                    onPressed: () {
                      _addData();
                    }),
                IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 40.0,
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
