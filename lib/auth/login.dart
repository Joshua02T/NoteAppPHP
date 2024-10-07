import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:notephp/constant/linkapi.dart';
import 'package:notephp/main.dart';

import '../components/crud.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  final Crud _crud = Crud();
  GlobalKey<FormState> mykey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  logIn() async {
    isLoading = true;
    setState(() {});
    var response = await _crud.postRequest(linkLogin,
        {"email": _emailcontroller.text, "password": _passwordcontroller.text});
    if (response["status"] == "success") {
      sharedpref.setString("id", response["data"]["id"].toString());
      Navigator.pushNamedAndRemoveUntil(context, 'homepage', (route) => false);
      isLoading = false;
      setState(() {});
    } else {
      isLoading = false;
      setState(() {});
      AwesomeDialog(
              context: context,
              title: 'error',
              body: const Text('Email not found or password is wrong'))
          .show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Form(
              key: mykey,
              child: Column(
                children: [
                  const Icon(Icons.language_outlined, size: 50),
                  TextFormField(
                    controller: _emailcontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "email cannot be empty!";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email)),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordcontroller,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return "password must eb at least 6 characters!";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.password)),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () async {
                      if (mykey.currentState!.validate()) {
                        await logIn();
                      }
                    },
                    color: Colors.red,
                    textColor: Colors.white,
                    height: 50,
                    minWidth: 200,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 25),
                          ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, 'signup');
                      },
                      child: const Text('Sign up'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
