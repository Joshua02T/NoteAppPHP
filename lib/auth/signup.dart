import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:notephp/components/crud.dart';
import 'package:notephp/constant/linkapi.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isLoading = false;
  final Crud _crud = Crud();
  GlobalKey<FormState> mykey = GlobalKey<FormState>();
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  signUp() async {
    isLoading = true;
    setState(() {});
    var response = await _crud.postRequest(linkSignup, {
      "username": _usernamecontroller.text,
      "email": _emailcontroller.text,
      "password": _passwordcontroller.text
    });
    if (response['status'] == 'success') {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              title: 'Success',
              body:
                  Text('you can log in now press anywhere to go to login page'))
          .show()
          .then((_) {
        Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
      });
      isLoading = false;
      setState(() {});
    } else {
      isLoading = false;
      setState(() {});
      AwesomeDialog(
              context: context,
              title: 'error',
              body: const Text('Signing in failed!'))
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
                  const Icon(Icons.open_in_browser_outlined, size: 50),
                  TextFormField(
                    controller: _usernamecontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "username cannot be empty!";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person)),
                  ),
                  const SizedBox(height: 10),
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
                        await signUp();
                      }
                    },
                    color: Colors.red,
                    textColor: Colors.white,
                    height: 50,
                    minWidth: 200,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Signup',
                            style: TextStyle(fontSize: 25),
                          ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, 'login');
                      },
                      child: const Text('Login'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
