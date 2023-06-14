import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_onwords/firebase_helper/firebase_auth.dart';
import 'package:task_onwords/screens/register_page.dart';

class Login_Page extends StatefulWidget {
  Login_Page({Key? key}) : super(key: key);

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  bool _isHidden = true;
  var visible = "";

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  Service service = Service();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                ),
                Center(
                  child: Text(
                    "LOGIN",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: emailcontroller,
                    decoration: InputDecoration(
                        hintText: 'Enter Email Id or Login Id',
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(25))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30, right: 20, left: 20),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: passwordcontroller,
                    obscureText: _isHidden,
                    decoration: InputDecoration(
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(color: Colors.black),
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
                        prefixIcon: Icon(
                          Icons.keyboard,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(25),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Container(
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal),
                        onPressed: () async {
                          setState(() {});
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          if (emailcontroller.text.isNotEmpty &&
                              passwordcontroller.text.isNotEmpty) {
                            service.loginUser(
                                context,
                                emailcontroller.text.trim(),
                                passwordcontroller.text);
                            pref.setString(
                                "email", emailcontroller.text.trim());
                          } else {
                            service.errorBox(context,
                                "Fields must not empty ,please provide valid email and password");
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Container(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                              },
                              child: Text(
                                "Don't have an Account?   ",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black),
                              ))),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
