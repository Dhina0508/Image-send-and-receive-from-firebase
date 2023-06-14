import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_onwords/firebase_helper/firebase_auth.dart';

class HomePage extends StatefulWidget {
  var user;
  HomePage({this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Service service = Service();

  String? link;
  ImagePicker image = ImagePicker();
  File? file;
  var click = "";
  var enter = "";

  String url = "";
  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  SendImage() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentuser = _auth.currentUser;
    String name = DateTime.now().millisecondsSinceEpoch.toString();
    var imageFile = FirebaseStorage.instance.ref().child("image").child(name);

    UploadTask task = imageFile.putFile(file!);
    TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();

    CollectionReference _CollectionReference =
        FirebaseFirestore.instance.collection("User_data");
    return _CollectionReference.doc(currentuser!.email).set({
      "img": url,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Image has been Added Sucessfully!"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ));
      setState(() {});
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("ERROR ${onError.toString()}"),
        behavior: SnackBarBehavior.floating,
      ));
    });
  }

  UpdateImage() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String name = DateTime.now().millisecondsSinceEpoch.toString();
    var imageFile = FirebaseStorage.instance.ref().child("image").child(name);

    UploadTask task = imageFile.putFile(file!);
    TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();
    var currentuser = _auth.currentUser;

    CollectionReference _CollectionReference =
        FirebaseFirestore.instance.collection("User_data");
    return _CollectionReference.doc(currentuser!.email)
        .update({"img": url}).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Image has been Updated Sucessfully!"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection("User_data");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                service.signOut(context);
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.remove("email");
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Text(
          'UPLOAD IMAGE',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(
              flex: 2,
            ),
            InkWell(
              onTap: () async {
                getImage();
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: file == null
                    ? AssetImage("images/profile.png")
                    : FileImage(File(file!.path)) as ImageProvider,
                child: enter == "" && widget.user == "old"
                    ? FutureBuilder<DocumentSnapshot>(
                        future: users
                            .doc(FirebaseAuth.instance.currentUser!.email)
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          enter = "1";
                          click = "1";

                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;

                            return Container(
                              height: double.infinity, width: double.infinity,
                              // margin: EdgeInsets.all(100.0),
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  data['img'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return CircularProgressIndicator();
                          }
                          return CircularProgressIndicator();
                        })
                    : null,
                radius: 80,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            click == "" && widget.user == "new"
                ? SizedBox(
                    height: 40,
                    width: 90,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              //to set border radius to button
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Colors.teal,
                        ),
                        onPressed: () async {
                          setState(() {
                            click = "1";
                            SendImage();
                          });
                        },
                        child: Text(
                          "Post",
                          style: TextStyle(fontSize: 17),
                        )),
                  )
                : SizedBox(
                    height: 40,
                    width: 80,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              //to set border radius to button
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Colors.teal,
                        ),
                        onPressed: () async {
                          UpdateImage();
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(fontSize: 17),
                        )),
                  ),
            Spacer(
              flex: 4,
            ),
          ],
        ),
      ),
    );
  }
}
