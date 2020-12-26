import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:AnimationAssignment/models/customer.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class Payment extends StatefulWidget {
  final int subTotal;
  Payment({this.subTotal});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final String publicKey = "pk_test_590a45fd56ca074e8f4f97488508b77623c7236e";
  String _getReference() {
    print("Payment Successful");
  }

  @override
  void initState() {
    PaystackPlugin.initialize(publicKey: publicKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _customer = Provider.of<Customer>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text("Total payment =   ${widget.subTotal}"),
          SizedBox(
            height: 200,
          ),
          FlatButton(
            color: Colors.orange,
            onPressed: () async {
              // Initialize the Paystack payment process

              Charge charge = Charge()
                ..amount = widget.subTotal
                ..reference = _getReference()
                ..email = _customer.email;
              CheckoutResponse response = await PaystackPlugin.checkout(
                context,
                method: CheckoutMethod
                    .card, // Defaults to CheckoutMethod.selectable
                charge: charge,
              );
            },
            child: Text("Make Payment"),
          ),
        ]),
      ),
    );
  }
}
