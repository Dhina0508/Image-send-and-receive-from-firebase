import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_onwords/screens/home_page.dart';
import 'package:task_onwords/screens/login_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences pref = await SharedPreferences.getInstance();
  var email = pref.getString('email');
  runApp(GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      home: email == null ? Login_Page() : HomePage()));
}
