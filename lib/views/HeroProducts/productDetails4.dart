import 'package:AnimationAssignment/models/customer.dart';
import 'package:AnimationAssignment/views/HomePage.dart';
import 'package:AnimationAssignment/views/cart_view.dart';
import 'package:AnimationAssignment/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final String productName;
  final String imageUrl;
  final int quantity;
  final price;
  final String brand;
  final String productId;
  final String description;
  ProductDetails(
      {this.productId,
      this.productName,
      this.imageUrl,
      this.quantity,
      this.price,
      this.brand,
      this.description});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  CollectionReference _productCol =
      FirebaseFirestore.instance.collection("products");
  CollectionReference _cartCol = FirebaseFirestore.instance.collection("cart");

  @override
  Widget build(BuildContext context) {
    Customer _customer = Provider.of<Customer>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text(widget.productName),
          elevation: 0,
          actions: [
            IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.googlePlay,
                  color: Colors.white,
                  size: 14,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return CartViewPage();
                  }));
                }),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(children: [
              Center(
                child: Hero(
                    tag: "product4",
                    child: Image.network(
                      widget.imageUrl,
                      scale: 2.5,
                    )),
              ),
              SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  Text(
                    "PRODUCT DETAILS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Text(
                        widget.description.toString(),
                        style: TextStyle(
                            fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  Text(
                    widget.price.toString(),
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Quantity: ${widget.quantity.toString()}"),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    onPressed: () {
                      if (_customer.uid == null) {
                        print(_customer.uid);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return Registerview();
                        }));
                      } else {
                        // var newQty = widget.quantity - 1;
                        // this reduced the products by 1
                        // DocumentReference _productDoc = _productCol.doc(widget
                        //     .productId); //widget.productId is the documentId
                        // _productDoc.update({"quantity": newQty}).then(
                        //     (_) => print("sucess"));

                        FirebaseFirestore.instance.collection("customers");

                        _cartCol.add({
                          "uid": _customer.uid,
                          "ProductId": widget.productId,
                          "Qty": 1,
                          "price": widget.price,
                          "Product": widget.productName,
                          "description": widget.description,
                        });
                        showModalBottomSheet(
                            backgroundColor: Colors.deepOrange,
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 170,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Column(
                                    children: [
                                      RaisedButton(
                                          child: Text("Return to Shopping"),
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return MyHomePage();
                                            }));
                                          }),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      RaisedButton(
                                          child: Text("Continue to Cart"),
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return CartViewPage();
                                            }));
                                          })
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    },
                    child: Text(
                      "+  ADD TO CART",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    color: Colors.deepOrange,
                  ),
                  SizedBox(height: 10),
                  //     Text("Share With Friends",
                  //         style: TextStyle(
                  //           fontSize: 15,
                  //           fontWeight: FontWeight.bold,
                  //         )),
                  //     SizedBox(height: 10),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         IconButton(
                  //             color: Colors.grey,
                  //             icon: FaIcon(
                  //               FontAwesomeIcons.twitter,
                  //               color: Colors.blue,
                  //             ),
                  //             onPressed: () {
                  //               FirebaseFirestore.instance
                  //                   .collection("products")
                  //                   .doc(widget.productId)
                  //                   .update({"price": widget.price - 200});
                  //             }),
                  //         IconButton(
                  //             color: Colors.grey,
                  //             icon: FaIcon(
                  //               FontAwesomeIcons.facebook,
                  //               color: Colors.blue,
                  //             ),
                  //             onPressed: () {}),
                  //         IconButton(
                  //             color: Colors.black,
                  //             icon: FaIcon(
                  //               FontAwesomeIcons.instagram,
                  //               color: Colors.deepOrange,
                  //             ),
                  //             onPressed: () {}),
                  //       ],
                  //     ),
                  //     SizedBox(height: 10),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // CarouselSlider(
                  //   options: CarouselOptions(
                  //       height: 100,
                  //       autoPlay: true,
                  //       autoPlayAnimationDuration: Duration(milliseconds: 50)),
                  //   items: [
                  //     Container(
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(12),
                  //         image: DecorationImage(
                  //           fit: BoxFit.contain,
                  //           image: AssetImage("assets/shoes/shoe15.jpeg"),
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(12),
                  //         image: DecorationImage(
                  //           fit: BoxFit.contain,
                  //           image: AssetImage("assets/shoes/shoe12.jpeg"),
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(12),
                  //         image: DecorationImage(
                  //           fit: BoxFit.contain,
                  //           image: AssetImage("assets/shoes/shoe1.jpeg"),
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(12),
                  //         image: DecorationImage(
                  //           fit: BoxFit.contain,
                  //           image: AssetImage("assets/shoes/shoe4.jpeg"),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ])));
  }
}
