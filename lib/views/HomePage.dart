import 'dart:io';

import 'package:AnimationAssignment/models/customer.dart';
import 'package:AnimationAssignment/services/admin.dart';
import 'package:AnimationAssignment/services/auth_servise.dart';
import 'package:AnimationAssignment/views/customerPage.dart';
import 'package:AnimationAssignment/views/login.dart';
import 'package:AnimationAssignment/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:AnimationAssignment/views/HeroProducts/productDetails4.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AnimationAssignment/views/cart_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthService _authService = AuthService();
  String customerName = "";
  File _image;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      PickedFile _imageFile =
          await _picker.getImage(source: ImageSource.gallery);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final customer = Provider.of<Customer>(context);
    if (customer != null) {
      DocumentReference _docRef =
          FirebaseFirestore.instance.collection("customers").doc(customer.uid);
      _docRef.get().then((customerDoc) {
        setState(() {
          customerName = customerDoc["fullname"];
        });

        // print(customerDoc["fullname"]);
      });
    }

    var mediaQuery = MediaQuery.of(context).size;
    double _height = mediaQuery.height;
    double _width = mediaQuery.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text("LEG UP!"),
        actions: [
          IconButton(
              icon: FaIcon(
                FontAwesomeIcons.cartPlus,
                color: Colors.white,
                size: 14,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return CartViewPage();
                }));
              }),
          customer != null
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("cart")
                      .where("uid", isEqualTo: customer.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data.docs);

                      if (snapshot.data.docs.length > 0) {
                        return RichText(
                            text: WidgetSpan(
                                child: Transform.translate(
                                    offset: const Offset(-25, 12),
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
                    ;
                  })
              : Text(" "),
        ],
      ),
      drawerScrimColor: Color.fromRGBO(0, 0, 255, 0.2),
      drawer: Drawer(
        child: customer == null
            ? Column(children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.deepOrange.shade300),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return Registerview();
                            }));
                          },
                          child: Text("REGISTER NOW",
                              style: TextStyle(color: Colors.white)),
                          color: Colors.orange.shade300,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return LoginPage();
                            }));
                          },
                          child: Text("LOG IN",
                              style: TextStyle(color: Colors.white)),
                          color: Colors.orange.shade300,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        )
                      ]),
                ),
              ])
            : Column(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.deepOrange),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/shoes/images.jpeg"),
                          radius: 40, //the size of the avatar
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$customerName",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Text(
                              '${customer.email}',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return CustomerPage();
                        }));
                      },
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.appStore,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Profile")
                        ],
                      ),
                    ),
                  ),
                  // ListTile(
                  //     leading:
                  //     ),
                  //     title: FlatButton(
                  //         onPressed: () {
                  //           CustomerPage();
                  //
                  //         },
                  //         child: Align(
                  //           child: ,
                  //           alignment: Alignment.topLeft,
                  //         ))),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: InkWell(
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.heart,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Wish List")
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: InkWell(
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.share,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Share App")
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: InkWell(
                      child: Row(
                        children: [
                          Icon(
                            Icons.settings,
                            color: Colors.orange,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Settings")
                        ],
                      ),
                    ),
                  ),

                  FlatButton(
                    onPressed: () async {
                      await _authService.signOut();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Log Out",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.orange.shade300,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ],
              ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("products").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data.docs);
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot product = snapshot.data.docs[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ProductDetails(
                              productId: product.id,
                              productName: product["product"],
                              imageUrl: product["URL"],
                              quantity: product["quantity"],
                              price: product["price"],
                              description: product["description"],
                            );
                          }));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0),
                          child: Card(
                            elevation: 3,

                            // height: _height * 0.2,
                            // width: _width * 0.2,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(12),
                            // ),
                            child: Column(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  child: product["URL"] != null
                                      ? Hero(
                                          tag: product["product"],
                                          child: Image.network(
                                            product["URL"],
                                            scale: 5,
                                          ),
                                        )
                                      : Hero(
                                          tag: product["product"],
                                          child: Image.asset(
                                            "assets/shoes/shoe13.jpeg",
                                            scale: 5,
                                          ),
                                        ),
                                ),
                                SizedBox(
                                  height: _height * 0.01,
                                ),
                                Text(
                                  product[
                                      "product"], // a specific value from the snapshot.data.docs[index]
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(product[
                                    "brand"]), // a specific value from the snapshot.data.docs[index]
                                Text(product["price"]
                                    .toString()), // a specific value from the snapshot.data.docs[index]
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return AdminPage();
          }));
        },
        child: Icon(Icons.do_not_disturb),
      ),
      // SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       CarouselSlider(
      //         options: CarouselOptions(
      //             height: 300,
      //             autoPlay: true,
      //             autoPlayAnimationDuration: Duration(milliseconds: 50)),
      //         items: [
      //           Container(
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(12),
      //               image: DecorationImage(
      //                 fit: BoxFit.contain,
      //                 image: AssetImage("assets/shoes/shoe11.jpeg"),
      //               ),
      //             ),
      //           ),
      //           Container(
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(12),
      //               image: DecorationImage(
      //                 fit: BoxFit.contain,
      //                 image: AssetImage("assets/shoes/shoe10.jpeg"),
      //               ),
      //             ),
      //           ),
      //           Container(
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(12),
      //               image: DecorationImage(
      //                 fit: BoxFit.contain,
      //                 image: AssetImage("assets/shoes/shoe3.jpeg"),
      //               ),
      //             ),
      //           ),
      //           Container(
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(12),
      //               image: DecorationImage(
      //                 fit: BoxFit.contain,
      //                 image: AssetImage("assets/shoes/shoe4.jpeg"),
      //               ),
      //             ),
      //           ),
      //           Container(
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(12),
      //               image: DecorationImage(
      //                 fit: BoxFit.contain,
      //                 image: AssetImage("assets/shoes/shoe1.jpeg"),
      //               ),
      //             ),
      //           )
      //         ],
      //       ),
      //       SizedBox(
      //         height: _height * 0.02,
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: [
      //           InkWell(
      //             onTap: () {
      //               Navigator.push(context,
      //                   MaterialPageRoute(builder: (BuildContext context) {
      //                 return ProductDetails(
      //                   productName: 'product1',
      //                   imageName: "assets/shoes/shoe2.jpeg",
      //                 );
      //               }));
      //             },
      //             child: Container(
      //               height: _height * 0.28,
      //               width: _width * 0.4,
      //               decoration: BoxDecoration(
      //                 color: Color(0xfff8c1c0),
      //                 borderRadius: BorderRadius.circular(12),
      //               ),
      //               child: Column(
      //                 children: [
      //                   Hero(
      //                     tag: "product1",
      //                     child: Image.asset(
      //                       "assets/shoes/shoe2.jpeg",
      //                       fit: BoxFit.contain,
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: _height * 0.02,
      //                   ),
      //                   Text(
      //                     "Gentle Jean",
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.bold, fontSize: 18),
      //                   ),
      //                   Text("Shop Now"),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           InkWell(
      //             onTap: () {
      //               Navigator.push(context,
      //                   MaterialPageRoute(builder: (BuildContext context) {
      //                 return ProductDetailsTwo(
      //                   productName: "product2",
      //                   imageName: "assets/shoes/shoe5.jpeg",
      //                 );
      //               }));
      //             },
      //             child: Container(
      //               height: _height * 0.28,
      //               width: _width * 0.4,
      //               decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(12),
      //                   color: Color(0xfff8c1c0)),
      //               child: Column(
      //                 children: [
      //                   Hero(
      //                     tag: "product2",
      //                     child: Image.asset(
      //                       "assets/shoes/shoe5.jpeg",
      //                       fit: BoxFit.contain,
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: _height * 0.02,
      //                   ),
      //                   Text(
      //                     "Neon Glam Up",
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.bold, fontSize: 18),
      //                   ),
      //                   Text("Shop Now"),
      //                 ],
      //               ),
      //             ),
      //           )
      //         ],
      //       ),
      //       SizedBox(
      //         height: 25,
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: [
      //           InkWell(
      //             onTap: () {
      //               Navigator.push(context,
      //                   MaterialPageRoute(builder: (BuildContext context) {
      //                 return ProductDetailsThree(
      //                   productName: "product3",
      //                   imageName: "assets/shoes/shoe13.jpeg",
      //                 );
      //               }));
      //             },
      //             child: Container(
      //               height: _height * 0.28,
      //               width: _width * 0.4,
      //               decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(12),
      //                   color: Color(0xfff8c1c0)),
      //               child: Column(
      //                 children: [
      //                   Hero(
      //                     tag: "product3",
      //                     child: Image.asset(
      //                       "assets/shoes/shoe13.jpeg",
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: _height * 0.02,
      //                   ),
      //                   Text(
      //                     "Elegant Piece",
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.bold, fontSize: 18),
      //                   ),
      //                   Text("Shop Now"),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           InkWell(
      //             onTap: () {
      //               Navigator.push(context,
      //                   MaterialPageRoute(builder: (BuildContext context) {
      //                 return ProductDetailsFour(
      //                   productName: "product4",
      //                   imageName: "assets/shoes/shoe6.jpeg",
      //                 );
      //               }));
      //             },
      //             child: Container(
      //               height: _height * 0.28,
      //               width: _width * 0.4,
      //               decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(12),
      //                   color: Color(0xfff8c1c0)),
      //               child: Column(
      //                 children: [
      //                   Hero(
      //                     tag: "product4",
      //                     child: Image.asset(
      //                       "assets/shoes/shoe6.jpeg",
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: _height * 0.02,
      //                   ),
      //                   Text(
      //                     "Clean Black",
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.bold, fontSize: 18),
      //                   ),
      //                   Text("Shop Now"),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (BuildContext context) {
      //       return AdminPage();
      //     }));
      //   },
      //   child: Icon(Icons.move_to_inbox),
      // ),
    );
  }
}
