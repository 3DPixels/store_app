import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_app/UserCustomer.dart';
import 'package:store_app/UserSeller.dart';
import 'package:store_app/loggedinhome.dart';
import 'package:store_app/register.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:email_validator/email_validator.dart';
import 'package:store_app/sellerhome.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String dropdownValue = 'Customer';
  bool flagSeller = false;
  bool flagCS = false;
  UserCustomer customer = UserCustomer();
  UserSeller seller = UserSeller();
  String Email;
  String pass;
  bool showSpinner = false;
  bool validate = false;
  // Initially password is obscure
  bool _obscureText = true;
  final _loginFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //Showing snackbar
  void _showSnackbar(String msg) {
    final snackbar = SnackBar(
      content: Text(msg),
      // duration: const Duration(seconds: 10),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  //toggling auto validate
  void _toggleValidate() {
    setState(() {
      validate = !validate;
    });
  }

  //toggling show\hide password
  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  //validator methods
  String validateEmail(String value) {
    value = value.trim();
    if (value.isEmpty) {
      return "please provide an email";
    } else if (!EmailValidator.validate(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String validatePassword(String value) {
    value = value.trim();
    if (value.isEmpty) {
      return "please provide a password";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidate: validate,
                        validator: validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          icon: Icon(Icons.email),
                          hintText: 'somone@something.com',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          Email = value.trim();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Column(
                        children: <Widget>[
                          new TextFormField(
                            autovalidate: validate,
                            obscureText: _obscureText,
                            validator: validatePassword,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                icon: Icon(Icons.vpn_key)),
                            onSaved: (value) {
                              pass = value.trim();
                            },
                          ),
                          new FlatButton(
                              onPressed: _togglePassword,
                              child: new Text(_obscureText ? "Show" : "Hide"))
                        ],
                      ),
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
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
                          dropdownValue = newValue;
                          if (dropdownValue == 'Seller') {
                            flagSeller = true;
                          } else if (dropdownValue == 'Customer') {
                            flagSeller = false;
                          }
                        });
                      },
                      items: <String>['Customer', 'Seller']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        color: Colors.blueGrey[900],
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => register()));
                        },
                        child: Text(
                          'New user?, Sign up here',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              color: Colors.blueGrey[900],
              onPressed: () async {
                if (_loginFormKey.currentState.validate()) {
                  setState(() {
                    showSpinner = true;
                  });
                  _loginFormKey.currentState.save();
                  try {
                    //If user was a seller
                    if (flagSeller) {
                      final DBRow =
                          await _firestore.collection('Sellers').get();
                      for (var usern in DBRow.docs) {
                        final firstname = usern.get('FirstName');
                        final lastname = usern.get('LastName');
                        final email = usern.get('Email');
                        if (email == Email) {
                          seller.firstName = firstname;
                          seller.lastName = lastname;
                        }
                      }
                      if (seller.firstName == 'temp') {
                        setState(() {
                          showSpinner = false;
                        });
                        _showSnackbar("Invalid email or password");
                      } else {
                        setState(() {
                          showSpinner = false;
                        });
                        final newuser = await _auth.signInWithEmailAndPassword(
                            email: Email, password: pass);
                        Navigator.pushNamed(context, sellerhome.id);
                      }
                    }
                    // User was a customer
                    else {
                      final userName =
                          await _firestore.collection('Customers').get();
                      for (var usern in userName.docs) {
                        final firstname = usern.get('FirstName');
                        final lastname = usern.get('LastName');
                        final email = usern.get('Email');
                        if (email == Email) {
                          customer.firstName = firstname;
                          customer.lastName = lastname;
                        }
                      }
                      if (customer.firstName == 'temp') {
                        setState(() {
                          showSpinner = false;
                        });
                        _showSnackbar("Invalid email or password");
                      } else {
                        setState(() {
                          showSpinner = false;
                        });
                        final newuser = await _auth.signInWithEmailAndPassword(
                            email: Email, password: pass);
                        Navigator.pushNamed(context, loggedinhome.id);
                      }
                    }
                  } catch (e) {
                    print(e);
                    setState(() {
                      showSpinner = false;
                    });
                    _showSnackbar("Invalid email or password");
                  }
                } else {
                  _toggleValidate();
                  _showSnackbar(
                      "Something went wrong, check the errors above please");
                }
              },
              child: Text(
                'Sign in',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
