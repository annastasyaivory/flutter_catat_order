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
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Order'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 7, 5, 7),
              child: TextField(
                onChanged: (String str) {
                  setState(() {
                    name = str;
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
              padding: const EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Choose Date",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    )),
                    FlatButton(
                        onPressed: () => _selectDueDate(context),
                        child: Text(
                          _dateText,
                          style: TextStyle(color: Colors.black54),
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (String str) {
                  setState(() {
                    phone = str;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                onChanged: (String str) {
                  setState(() {
                    alamat = str;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(5.0)),
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
                        return Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: DropdownButton(
                            underline: SizedBox(),
                            items: currencyProducts,
                            onChanged: (selectedProduct) {
                              setState(() {
                                product1 = selectedProduct;
                                product = product1;
                              });
                            },
                            isExpanded: true,
                            value: product1,
                            hint: new Text(
                              "Choose Products",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        );
                      }
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (String str) {
                  setState(() {
                    total = str;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Total',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: new DropdownButton<String>(
                    items:
                        <String>['Full Payment', 'Pending'].map((String str) {
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
                    underline: SizedBox(),
                    isExpanded: true,
                    value: status1,
                    hint: Text(
                      'Choose Status Payment',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
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
                        _addData();
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
