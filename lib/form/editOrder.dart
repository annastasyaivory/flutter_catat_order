import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditOrder extends StatefulWidget {
  EditOrder(
      {this.alamat,
      this.total,
      this.metodeBayar,
      this.ekspedisi,
      this.status,
      this.date,
      this.name,
      this.phone,
      this.index});
  final String name;
  final String phone;
  final String alamat;
  final String total;
  final String metodeBayar;
  final String ekspedisi;
  final String status;
  final DateTime date;
  final index;
  @override
  _EditOrderState createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  TextEditingController controllerName;
  TextEditingController controllerPhone;
  TextEditingController controllerAlamat;
  TextEditingController controllerTotal;
  TextEditingController controllerMetodeBayar;
  TextEditingController controllerEkspedisi;
  TextEditingController controllerStatus;

  DateTime _dueDate;
  String _dateText = '';

  String name;
  String phone;
  String alamat = '';
  String total = '';
  String metodeBayar = '';
  String ekspedisi = '';
  String status = '';

  void _updateOrder() {
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(widget.index);
      await transaction.update(snapshot.reference, {
        "name": name,
        "alamat": alamat,
        "total": total,
        "metodeBayar": metodeBayar,
        "eskpedisi": ekspedisi,
        "status": status,
        "date": _dueDate,
        "phone": phone,
      });
    });
    Navigator.pop(context);
  }

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

  @override
  void initState() {
    super.initState();
    _dueDate = widget.date; //toDate()
    _dateText = "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";

    name = widget.name;
    phone = widget.phone;
    alamat = widget.alamat;
    total = widget.total;
    metodeBayar = widget.metodeBayar;
    ekspedisi = widget.ekspedisi;
    status = widget.ekspedisi;

    controllerName = new TextEditingController(text: widget.name);
    controllerPhone = new TextEditingController(text: widget.phone);
    controllerAlamat = new TextEditingController(text: widget.alamat);
    controllerTotal = new TextEditingController(text: widget.total);
    controllerMetodeBayar = new TextEditingController(text: widget.metodeBayar);
    controllerEkspedisi = new TextEditingController(text: widget.ekspedisi);
    controllerStatus = new TextEditingController(text: widget.status);
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
                    "Edit Order",
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
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: controllerName,
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
            padding: const EdgeInsets.all(5.0),
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
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: controllerPhone,
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
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: controllerAlamat,
              onChanged: (String str) {
                setState(() {
                  alamat = str;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.phone),
                hintText: "Alamat",
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 22.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: controllerTotal,
              onChanged: (String str) {
                setState(() {
                  total = str;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.phone),
                hintText: "Total Belanja",
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 22.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: controllerMetodeBayar,
              onChanged: (String str) {
                setState(() {
                  metodeBayar = str;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.phone),
                hintText: "Metode Bayar (Transfer / Shopee)",
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 22.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: controllerEkspedisi,
              onChanged: (String str) {
                setState(() {
                  ekspedisi = str;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.phone),
                hintText: "Ekspedisi",
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 22.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: controllerStatus,
              onChanged: (String str) {
                setState(() {
                  status = str;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.phone),
                hintText: "Status (Lunas/Pending)",
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
                      _updateOrder();
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
