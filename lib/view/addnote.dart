import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notephp/constant/linkapi.dart';
import 'package:notephp/main.dart';

import '../components/crud.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  File? myfile;
  bool isLoading = false;
  final Crud _crud = Crud();
  final GlobalKey<FormState> _mykey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  addNote() async {
    if (myfile == null) {
      return AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'warning',
          body: const Text('upload a photo'))
        ..show();
    }

    isLoading = true;
    setState(() {});
    var response = await _crud.postRequestWithFile(
        linkaddnote,
        {
          "title": _titleController.text,
          "content": _subtitleController.text,
          "id": sharedpref.getString("id")
        },
        myfile!);
    if (response["status"] == "success") {
      isLoading = false;
      setState(() {});
      Navigator.pushNamedAndRemoveUntil(
        context,
        'homepage',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 20,
        shadowColor: Colors.black,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Add you note!',
          style: TextStyle(
              fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _mykey,
              child: Column(
                children: [
                  const Text(
                    'add your note info here!',
                    style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "title cannot be empty!";
                      }
                      return null;
                    },
                    controller: _titleController,
                    decoration: const InputDecoration(
                        hintText: 'title',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title_rounded)),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "subtitle cannot be empty!";
                      }
                      return null;
                    },
                    controller: _subtitleController,
                    decoration: const InputDecoration(
                        hintText: 'content',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.subtitles_rounded)),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          padding: const EdgeInsets.all(10),
                          height: 150,
                          child: Column(
                            children: [
                              const Text('Choose an option',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  MaterialButton(
                                    onPressed: () async {
                                      XFile? xfile = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.camera);
                                      Navigator.pop(context);
                                      myfile = File(xfile!.path);
                                      setState(() {});
                                    },
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                    child: const Text('Camera'),
                                  ),
                                  MaterialButton(
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                    onPressed: () async {
                                      XFile? xfile = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      Navigator.pop(context);
                                      myfile = File(xfile!.path);
                                      setState(() {});
                                    },
                                    child: const Text('Gallery'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    minWidth: 200,
                    height: 50,
                    color: myfile == null ? Colors.blue : Colors.green,
                    textColor: Colors.white,
                    child: isLoading
                        ? const LinearProgressIndicator(color: Colors.red)
                        : const Text('choose image'),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () async {
                      if (_mykey.currentState!.validate()) {
                        await addNote();
                      }
                    },
                    minWidth: 200,
                    height: 50,
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: isLoading
                        ? const LinearProgressIndicator(color: Colors.red)
                        : const Text('Add'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
