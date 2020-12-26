// import 'package:AnimationAssignment/views/HeroProducts/productDetails3.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProductViews extends StatefulWidget {
//   @override
//   _ProductViewsState createState() => _ProductViewsState();
// }

// class _ProductViewsState extends State<ProductViews> {
//   @override
//   Widget build(BuildContext context) {
//     var _height = MediaQuery.of(context).size.height;
//     var _width = MediaQuery.of(context).size.width;

//     return Scaffold(
//         appBar: AppBar(),
//         body: Container(
//           child: StreamBuilder(
//               stream:
//                   FirebaseFirestore.instance.collection("products").snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   print(snapshot.data.docs);
//                   return GridView.builder(
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2),
//                       itemCount: snapshot.data.docs.length,
//                       itemBuilder: (context, index) {
//                         DocumentSnapshot product = snapshot.data.docs[index];
//                         return InkWell(
//                           onTap: () {
//                             Navigator.push(context, MaterialPageRoute(
//                                 builder: (BuildContext context) {
//                               return ProductDetailsThree(
//                                 productName: "product3",
//                                 imageName: "assets/shoes/shoe13.jpeg",
//                               );
//                             }));
//                           },
//                           child: Container(
//                             height: _height * 0.2,
//                             width: _width * 0.2,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Column(
//                               children: [
//                                 Hero(
//                                   tag: "product3",
//                                   child: Image.asset(
//                                     "assets/shoes/shoe13.jpeg",
//                                     scale: 5,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: _height * 0.02,
//                                 ),
//                                 Text(
//                                   product[
//                                       "product"], // a specific value from the snapshot.data.docs[index]
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18),
//                                 ),
//                                 Text(product[
//                                     "brand"]), // a specific value from the snapshot.data.docs[index]
//                                 Text(product[
//                                     "price"]), // a specific value from the snapshot.data.docs[index]
//                               ],
//                             ),
//                           ),
//                         );
//                       });
//                 } else {
//                   return CircularProgressIndicator();
//                 }
//               }),
//         ));
//   }
// }
