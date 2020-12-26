import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:AnimationAssignment/models/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  String customerName;

  @override
  Widget build(BuildContext context) {
    final _customer = Provider.of<Customer>(context);
    if (_customer != null) {
      DocumentReference _docRef =
          FirebaseFirestore.instance.collection("customers").doc(_customer.uid);
      _docRef.get().then((customerDoc) {
        setState(() {
          customerName = customerDoc["fullname"];
        });

        // print(customerDoc["fullname"]);
      });
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/shoes/images.jpeg"),
              radius: 40,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              child: Card(
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${customerName}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              child: Card(
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${_customer.email}',
                    style: TextStyle(color: Colors.lightBlue, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
