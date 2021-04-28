import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class addProjector extends StatefulWidget {
  @override
  _addProjectorState createState() => _addProjectorState();
}

class _addProjectorState extends State<addProjector> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  File _image;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _addPcAccessoriesFormKey = GlobalKey<FormState>();
  bool validate = false;
  String description, name, searchKey, quantity, accessoryType;
  String picURL;
  String ddBrand = 'Unic';
  String ddType = 'LED';
  double price;

  //Getting the image
  Future getImage() async {
    var pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_image.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$name');
    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print('done $value'),
        );
    await taskSnapshot.ref.getDownloadURL().then((value) => picURL = value);
    _firestore.collection('SellerProduct').add({
      'Name': name,
      'Price': price,
      'imgURL': picURL,
      'SellerID': _auth.currentUser.email
    });
  }

  //toggling auto validate
  void _toggleValidate() {
    setState(() {
      validate = !validate;
    });
  }

  String validateEmpty(String value) {
    if (value.isEmpty) {
      return "This field is required";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add a PC Accessory"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.camera_alt,
                ),
                Container(
                  child: _image == null
                      ? Text('No image selected.')
                      : Image.file(_image),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Form(
              key: _addPcAccessoriesFormKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      autovalidate: validate,
                      validator: validateEmpty,
                      decoration: InputDecoration(
                        labelText: 'Device name',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        name = value.trim();
                        searchKey = name.substring(0, 1);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      autovalidate: validate,
                      validator: validateEmpty,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        description = value.trim();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      autovalidate: validate,
                      validator: validateEmpty,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        price = double.parse(value.trim());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      autovalidate: validate,
                      validator: validateEmpty,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        quantity = value.trim();
                      },
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Type'),
                    SizedBox(
                      width: 20,
                    ),
                    DropdownButton<String>(
                      value: ddType,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 10,
                      elevation: 10,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 1,
                        color: Colors.black,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          ddType = newValue;
                        });
                      },
                      items: <String>[
                        'LED',
                        'DIP',
                        'LCD',
                        'CRT',
                        'SXRD',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Brand'),
                    SizedBox(
                      width: 20,
                    ),
                    DropdownButton<String>(
                      value: ddBrand,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 10,
                      elevation: 10,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 1,
                        color: Colors.black,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          ddBrand = newValue;
                        });
                      },
                      items: <String>[
                        'Unic',
                        'Cyber',
                        'Viewsonic',
                        'Optoma',
                        'Benq',
                        'Sony',
                        'Epson',
                        'other',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        backgroundColor: Colors.blueGrey[900],
        child: Icon(Icons.add_a_photo),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              color: Colors.blueGrey[900],
              onPressed: () async {
                if (_addPcAccessoriesFormKey.currentState.validate()) {
                  _addPcAccessoriesFormKey.currentState.save();
                  uploadImageToFirebase(context);
                  _firestore.collection('PCAccesory').add({
                    'SearchKey': name.substring(0, 1),
                    'Seller Email': _auth.currentUser.email,
                    'Product Name': name,
                    'Description': description,
                    'Price': price,
                    'Quantity': quantity,
                    'Rating': 0
                  });

                  Navigator.pop(context);
                } else {
                  _toggleValidate();
                }
              },
              child: Text(
                'Add product',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}