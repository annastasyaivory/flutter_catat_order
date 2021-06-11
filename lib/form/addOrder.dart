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
  DateTime _dueDate = new DateTime.now(); //tanggal dibuka aplikasi
  String _dateText = ''; //untuk menyimpan data tanggal yang dipilih

  //var untuk field
  String name = '';
  String phone = '';
  String alamat = '';
  String product = '';
  String product1;
  String total = '';
  String status = '';
  String
      status1; //var sementara buat print value status di dropdown setelah dipilih

  //fungsi untuk menghandle date picker
  Future<Null> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _dueDate, //menampilkan tanggal hari ini
        firstDate: DateTime(2021),
        lastDate: DateTime(2080));
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dateText =
            "${picked.day}/${picked.month}/${picked.year}"; //format date
      });
    }
  }

  void _addData() {
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      //collection reference using .add(data)
      //document reference using .set(data)
      CollectionReference reference = FirebaseFirestore.instance
          .collection('order'); //adding data to collection named order
      await reference.add({
        //field of order collection
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
    _dateText =
        "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}"; //untuk meng-set data tanggal yang ditampilkan pertama yaitu tanggal hari ini
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
          //list view scrollable
          children: <Widget>[
            //add name of customer
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
            //choosing date order
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
            //add phone number
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
            //add customer address
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
            //menambahkan produk yang pelanggan beli
            //data produk berupa dropdown yang datanya diambil dari collection product
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(5.0)),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("product")
                        .snapshots(), //mengambil data di firestore database
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return new Container(
                          child: Center(
                            child:
                                CircularProgressIndicator(), //menunjukkan bahwa aplikasi sedang sibuk (loading...)
                          ),
                        );
                      else {
                        List<DropdownMenuItem> currencyProducts = [];
                        for (int i = 0; i < snapshot.data.docs.length; i++) {
                          var snap = snapshot.data.docs[i]
                              .data(); //menampilkan data collection product
                          String pro = snap['nama']; //yang ada di field 'nama'
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
                                product =
                                    product1; //menyimpan pada var product sesuai product yang telah dipilih lewat dropdown
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
            //add total harga
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
            //adding status payment
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
                        status =
                            status1; //menyimpan pada var status sesuai apa yg dipilih di dropdown
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
                        Navigator.pop(context); //kembali ke halaman sebelumnya
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
                        _addData(); //memanggil fungsi untuk menyimpan dan menambahkan data ke firestore database
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
