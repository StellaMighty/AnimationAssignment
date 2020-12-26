import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formkey = GlobalKey<FormState>();
  File _image;
  String _uploadedImageUrl;

  Future uploadImage() async {
    if (_image != null) {
      String _imageName = basename(_image.path);
      Reference _storageRef =
          FirebaseStorage.instance.ref().child("product_images/$_imageName");
      await _storageRef.putFile(_image);
      await _storageRef.getDownloadURL().then((value) {
        setState(() {
          _uploadedImageUrl = value;
        });
      });
    } else {}
  }

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      PickedFile _imageFile =
          await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        _image = File(_imageFile.path);
      });
      print(_image.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  TextEditingController productController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  CollectionReference _productCol =
      FirebaseFirestore.instance.collection("products");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    RaisedButton(
                      onPressed: () async {
                        await getImage();
                        // await uploadImage();
                      },
                      child: Text("Select Image from Gallery"),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter the Product Name";
                        } else {
                          return null;
                        }
                      },
                      controller: productController,
                      decoration: InputDecoration(hintText: "Product Name"),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please Enter the Brand name";
                        } else {
                          return null;
                        }
                      },
                      controller: brandController,
                      decoration: InputDecoration(hintText: "Brand Name"),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please Enter the Price";
                        } else {
                          return null;
                        }
                      },
                      controller: priceController,
                      decoration: InputDecoration(hintText: "Price"),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter the quantity";
                        } else {
                          return null;
                        }
                      },
                      controller: quantityController,
                      decoration: InputDecoration(hintText: "Quantity"),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter description";
                        } else {
                          return null;
                        }
                      },
                      controller: descriptionController,
                      decoration: InputDecoration(hintText: "Description"),
                    ),
                    FlatButton(
                      color: Color(0xfff8c1c0),
                      onPressed: () async {
                        if (_formkey.currentState.validate()) {
                          String product = productController.text;
                          String brand = brandController.text;
                          String price = priceController.text;
                          String quantity = quantityController.text;
                          String description = descriptionController.text;
                          await uploadImage();
                          _productCol.add({
                            "product": product,
                            "brand": brand,
                            "price": price,
                            "quantity": int.parse(quantity),
                            "description": description,
                            "URL": _uploadedImageUrl
                          });
                          print("success");
                          productController.clear();
                          brandController.clear();
                          priceController.clear();
                          quantityController.clear();
                          descriptionController.clear();
                          SnackBar(
                            content: Text("Sucessfully Uploaded"),
                          );
                        } else {
                          // Navigator.pop(context);
                        }
                      },
                      child: Text("Upload"),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
