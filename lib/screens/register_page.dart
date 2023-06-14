import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_helper/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _confirmpasswordcontroller = TextEditingController();
  TextEditingController _NameController = TextEditingController();
  senddata() async {
    final _CollectionReference = FirebaseFirestore.instance
        .collection("User_data")
        .doc(_emailcontroller.text.toString());
    return _CollectionReference.set({
      "Name": _NameController.text,
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("ERROR ${onError.toString()}"),
        behavior: SnackBarBehavior.floating,
      ));
    });
  }

  bool _isHidden = true;
  bool _isHidden1 = true;
  var visible = "";
  var visible1 = "";
  Service service = Service();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        // backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 100, right: 35, left: 35),
            child: Column(
              children: [
                Text(
                  'REGISTER ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: _NameController,
                  decoration: InputDecoration(
                      hintText: 'Enter your Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _emailcontroller,
                  decoration: InputDecoration(
                      hintText: 'Enter Email Id',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  obscureText: _isHidden,
                  controller: _passwordcontroller,
                  decoration: InputDecoration(
                      suffixIcon: visible == ""
                          ? InkWell(
                              onTap: () {
                                _togglePasswordView();
                                visible = "1";
                              },
                              child: Icon(
                                Icons.visibility_off,
                                size: 25,
                              ))
                          : InkWell(
                              onTap: () {
                                _togglePasswordView();
                                visible = "";
                              },
                              child: Icon(
                                Icons.visibility,
                                size: 25,
                              )),
                      hintText: 'Enter Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  obscureText: _isHidden1,
                  controller: _confirmpasswordcontroller,
                  decoration: InputDecoration(
                      suffixIcon: visible1 == ""
                          ? InkWell(
                              onTap: () {
                                _togglePasswordView1();
                                visible1 = "1";
                              },
                              child: Icon(
                                Icons.visibility_off,
                                size: 25,
                              ))
                          : InkWell(
                              onTap: () {
                                _togglePasswordView1();
                                visible1 = "";
                              },
                              child: Icon(
                                Icons.visibility,
                                size: 25,
                              )),
                      hintText: 'Re-Enter Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
                SizedBox(
                  height: 45,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Sign In',
                          style: TextStyle(
                              color: Colors.teal,
                              fontSize: 26,
                              fontWeight: FontWeight.w700)),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.teal,
                      child: IconButton(
                          color: Colors.white,
                          onPressed: () async {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            if (_passwordcontroller.text ==
                                _confirmpasswordcontroller.text) {
                              if (_emailcontroller.text.isNotEmpty &&
                                  _passwordcontroller.text.isNotEmpty) {
                                service.createUser(
                                    context,
                                    _emailcontroller.text.toString().trim(),
                                    _passwordcontroller.text);
                                pref
                                    .setString("email",
                                        _emailcontroller.text.toString().trim())
                                    .then((value) => senddata());
                              } else {
                                service.errorBox(context,
                                    "Fields must not empty ,please provide valid email and password");
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text("ERROR : Passwords should be Same"),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.red,
                              ));
                            }
                          },
                          icon: Icon(Icons.arrow_forward)),
                    )
                  ],
                ),
                SizedBox(
                  height: 45,
                ),
              ],
            ),
          ),
        ));
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _togglePasswordView1() {
    setState(() {
      _isHidden1 = !_isHidden1;
    });
  }
}
