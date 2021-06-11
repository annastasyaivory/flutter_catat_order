import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditOrder extends StatefulWidget {
  //menerima parameter dari halaman sebelumnya
  EditOrder(
      {this.product,
      this.alamat,
      this.total,
      this.status,
      this.date,
      this.name,
      this.phone,
      this.index});
  final String name;
  final String phone;
  final String alamat;
  final String total;
  final String status;
  final DateTime date;
  final index;
  final String product;
  @override
  _EditOrderState createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  //menghandle isian text field
  TextEditingController controllerName;
  TextEditingController controllerPhone;
  TextEditingController controllerAlamat;
  TextEditingController controllerTotal;
  TextEditingController controllerStatus;
  TextEditingController controllerProduct;

  DateTime _dueDate;
  String _dateText = '';

  //inisialisasi var
  String name;
  String phone;
  String alamat = '';
  String product = '';
  String product1;
  String total = '';
  String status = '';
  String status1;

  void _updateOrder() {
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      //document snapshot membaca dokumen di firebase
      DocumentSnapshot snapshot =
          await transaction.get(widget.index); //dibaca sesuai indeks
      await transaction.update(snapshot.reference, {
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
    //agar data terupdate
    super.initState();
    _dueDate = widget.date;
    _dateText = "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";

    name = widget.name;
    phone = widget.phone;
    alamat = widget.alamat;
    product = widget.product;
    total = widget.total;
    status = widget.status;

    controllerName = new TextEditingController(text: widget.name);
    controllerPhone = new TextEditingController(text: widget.phone);
    controllerAlamat = new TextEditingController(text: widget.alamat);
    controllerTotal = new TextEditingController(text: widget.total);
    controllerStatus = new TextEditingController(text: widget.status);
    controllerProduct = new TextEditingController(text: widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Order'),
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
                controller: controllerName,
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
              padding: const EdgeInsets.all(5.0),
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
                        style: TextStyle(fontSize: 16.0, color: Colors.black54),
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
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: controllerPhone,
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
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: controllerAlamat,
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
                            // value: product1,
                            isExpanded: true,
                            hint: new Text(
                              product,
                              style: TextStyle(color: Colors.black),
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
                controller: controllerTotal,
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
                  padding: const EdgeInsets.only(left: 10, right: 10),
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
                    // value: status1,
                    underline: SizedBox(),
                    isExpanded: true,
                    hint: Text(
                      status,
                      style: TextStyle(color: Colors.black),
                    ),
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
                        _updateOrder();
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
