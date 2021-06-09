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
  String alamat = '';
  String product = '';
  String product1;
  String total = '';
  String status = '';
  String
      status1; //var sementara buat print value status di dropdown setelah dipilih

  // var status;
  // final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  // List<String> _statusType = <String>['Full Payment', 'Pending'];

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
        "alamat": alamat,
        "product": product,
        "total": total,
        "status": status,
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
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Add Order",
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
                  name = str;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.person_pin),
                hintText: "Nama Customer",
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
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("product")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return new Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  else {
                    List<DropdownMenuItem> currencyProducts = [];
                    for (int i = 0; i < snapshot.data.docs.length; i++) {
                      var snap = snapshot.data.docs[i].data();
                      String pro = snap['nama'];
                      currencyProducts.add(
                        DropdownMenuItem(
                          child: Text(pro),
                          value: "$pro",
                        ),
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        DropdownButton(
                          items: currencyProducts,
                          onChanged: (selectedProduct) {
                            setState(() {
                              product1 = selectedProduct;
                              product = product1;
                            });
                          },
                          value: product1,
                          hint: new Text(
                            "Choose Products",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new DropdownButton<String>(
                  items: <String>['Full Payment', 'Pending'].map((String str) {
                    return new DropdownMenuItem<String>(
                      value: str,
                      child: new Text(str),
                    );
                  }).toList(),
                  onChanged: (selectedStatus) {
                    setState(() {
                      status1 = selectedStatus;
                      status = status1;
                    });
                  },
                  value: status1,
                  hint: Text(
                    'Choose Status Payment',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
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
                      _addData();
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
