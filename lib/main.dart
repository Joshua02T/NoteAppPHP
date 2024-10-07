import 'package:flutter/material.dart';
import 'package:notephp/auth/login.dart';
import 'package:notephp/auth/signup.dart';
import 'package:notephp/view/addnote.dart';
import 'package:notephp/view/editnode.dart';
import 'package:notephp/view/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedpref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedpref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: sharedpref.getString("id") == null ? 'login' : 'homepage',
      routes: {
        "login": (context) => const Login(),
        "addnote": (context) => const AddNote(),
        "editnote": (context) => const EditNote(),
        "signup": (context) => const Signup(),
        "homepage": (context) => const HomePage()
      },
    );
  }
}
