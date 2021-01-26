import 'package:AnimationAssignment/models/customer.dart';
import 'package:AnimationAssignment/views/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'HomePage.dart';

class CartViewPage extends StatefulWidget {
  @override
  _CartViewPageState createState() => _CartViewPageState();
}

class _CartViewPageState extends State<CartViewPage> {
  @override
  Widget build(BuildContext context) {
    Customer _customer = Provider.of<Customer>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return MyHomePage();
              }));
            }),
        title: Text("Your Cart"),
        actions: [
          IconButton(
              icon: FaIcon(
                FontAwesomeIcons.cartPlus,
                color: Colors.white,
                size: 14,
              ),
              onPressed: null),
          _customer != null
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("cart")
                      .where("uid", isEqualTo: _customer.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data.docs);

                      if (snapshot.data.docs.length > 0) {
                        return RichText(
                            text: WidgetSpan(
                                child: Transform.translate(
                                    offset: const Offset(-18, 14),
                                    child: Text(
                                      snapshot.data.docs.length.toString(),
                                      textScaleFactor: 0.7,
                                    ))));
                      } else {
                        return Text(" ");
                      }
                    } else {
                      return Text(" ");
                    }
                  })
              : Text(" "),
        ],
      ),
      body: SafeArea(
        child: _customer != null
            ?

            // StreamBuilder(
            //     stream: FirebaseFirestore.instance.collection("cart").snapshots(),
            //     builder: (context, snapshot) {
            //       return ListView.builder(
            //           itemCount: snapshot.data.docs.length,
            //           itemBuilder: (context, index) {
            //             final CollectionReference _cartCol =
            //                 FirebaseFirestore.instance.collection("cart");
            //             _cartCol.get();
            //             print(_cartCol.get());
            //             return ListTile(
            //               title: Text(${_cartCol.get(     "Product")}),
            //             );
            //           });
            //     }),

            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("cart")
                    .where("uid",
                        isEqualTo: _customer
                            .uid) // where user id is equal to this particular user
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data.docs);
                    int totalPrice = 0;
                    if (snapshot.data.docs.length > 0) {
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                padding: EdgeInsets.only(bottom: 20, top: 20),
                                itemCount: snapshot.data.docs.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == (snapshot.data.docs.length)) {
                                    return Container(
                                      child: Column(
                                        children: [
                                          Text(" Total Price = " +
                                              "$totalPrice"),
                                          Container(
                                            width: 200,
                                            child: RaisedButton(
                                                // shape: RoundedRectangleBorder(
                                                //     borderRadius:
                                                // BorderRadius.circular(30)),
                                                color: Colors.orange,
                                                onPressed: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(builder:
                                                          (BuildContext
                                                              context) {
                                                    return Payment(
                                                      subTotal: totalPrice,
                                                    );
                                                  }));
                                                },
                                                child: Text(
                                                  "Check Out",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    DocumentSnapshot _cartResult =
                                        snapshot.data.docs[index];
                                    final CollectionReference _cartCol =
                                        FirebaseFirestore.instance
                                            .collection("cart");

                                    DocumentReference _cartDoc =
                                        _cartCol.doc(_cartResult.id);

                                    totalPrice +=
                                        int.parse(_cartResult["price"]) *
                                            (_cartResult["Qty"]);

                                    return Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 100,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection("products")
                                                        .doc(_cartResult[
                                                            'ProductId'])
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right:
                                                                        10.0),
                                                            child:
                                                                Image.network(
                                                              snapshot
                                                                  .data['URL'],
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        return Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                          child: Image.asset(
                                                              "images.png"),
                                                        );
                                                      }
                                                    }),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        _cartResult["Product"],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text("N " +
                                                          _cartResult["price"]
                                                              .toString()),
                                                      Text(
                                                        _cartResult[
                                                                "description"] ??
                                                            "No Details",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FlatButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Delete Confirmation"),
                                                        content: Text(
                                                            "Are you sure ?"),
                                                        actions: [
                                                          FlatButton(
                                                              onPressed: () {
                                                                _cartDoc
                                                                    .delete()
                                                                    .then((_) {
                                                                  print(
                                                                      "Item Deleted");
                                                                });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                  "Remove")),
                                                          FlatButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text("No"))
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      color: Colors
                                                          .orange.shade600,
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      "Remove",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .orange.shade400),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      color: Colors.green,
                                                      icon: FaIcon(
                                                        FontAwesomeIcons.minus,
                                                        color: Colors.black,
                                                        size: 14,
                                                      ),
                                                      onPressed: () {
                                                        CollectionReference
                                                            _cartQtyCol =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "cart");
                                                        DocumentReference
                                                            _qtyDoc =
                                                            _cartQtyCol.doc(
                                                                _cartResult.id);
                                                        if (_cartResult["Qty"] >
                                                            1) {
                                                          _qtyDoc.update({
                                                            "Qty": _cartResult[
                                                                    "Qty"] -
                                                                1
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: 20,
                                                      ),
                                                      child: CircleAvatar(
                                                        backgroundColor: Colors
                                                            .orange.shade300,
                                                        radius: 10,
                                                        child: Text(
                                                          _cartResult["Qty"]
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      color: Colors.green,
                                                      icon: FaIcon(
                                                        FontAwesomeIcons.plus,
                                                        size: 14,
                                                      ),
                                                      onPressed: () {
                                                        CollectionReference
                                                            _cartQtyCol =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "cart");
                                                        DocumentReference
                                                            _qtyDoc =
                                                            _cartQtyCol.doc(
                                                                _cartResult.id);
                                                        _qtyDoc.update({
                                                          "Qty": _cartResult[
                                                                  "Qty"] +
                                                              1
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          // Text("Total Price =" +
                                          //     totalPrice.toString()),
                                        ],
                                      ),
                                    );
                                  }

                                  // ListTile(
                                  //   //leading: Text(),
                                  //   title: Text(_cartResult["Product"]),
                                  //   subtitle: Text(_cartResult["Qty"].toString()),
                                  //   trailing: Text(_cartResult["price"].toString()),
                                  // );

                                  // print(_cartResult);
                                  // // String uid = _customer.uid;
                                  // String pid = _proid.productId;
                                  // String productName = "";

                                  // final CollectionReference _cartCol =
                                  //     FirebaseFirestore.instance.collection("cart");
                                  // DocumentReference _cartDoc = _cartCol.doc(pid);
                                  // _cartDoc.get().then((_cartDoc) {
                                  //  print(_cartDoc["Product"]);
                                }),
                          ),
                        ],
                      );
                    } else {
                      return Padding(
                          padding: const EdgeInsets.only(top: 10, left: 100),
                          child: Text(
                            "No Item in cart",
                            style: TextStyle(
                                fontSize: 16, color: Colors.blue.shade900),
                          ));
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                })
            : Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Login to view cart",
                    style: TextStyle(fontSize: 16, color: Colors.blue.shade900),
                  ),
                ),
              ),
      ),
    );
  }
}
