import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:notephp/components/crud.dart';
import 'package:notephp/components/notecard.dart';
import 'package:notephp/constant/linkapi.dart';
import 'package:notephp/main.dart';
import 'package:notephp/model/viewnotemodel.dart';
import 'package:notephp/view/editnode.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Crud _crud = Crud();
  getNotes() async {
    var response = await _crud
        .postRequest(linkviewnote, {"id": sharedpref.getString("id")});
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.pushNamed(context, 'addnote');
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        elevation: 5,
        shadowColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              sharedpref.clear();
              Navigator.pushNamedAndRemoveUntil(
                  context, "login", (route) => false);
            },
            icon: const Icon(Icons.logout, color: Colors.white, size: 25),
          )
        ],
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'HomePage',
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(children: [
          FutureBuilder(
              future: getNotes(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data['status'] == "fail") {
                    return const Center(child: Text('No Notes'));
                  }
                  return ListView.builder(
                      itemCount: snapshot.data['data'].length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return CardNote(
                            viewnote:
                                ViewNote.fromJson(snapshot.data['data'][i]),
                            ontap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => EditNote(
                                          notes: snapshot.data['data'][i]))));
                            },
                            onlongpress: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                title: 'Warnign',
                                body: const Text(
                                    'Are you sure you want to delete this note?'),
                                btnOkOnPress: () async {
                                  var response =
                                      await _crud.postRequest(linkdeletenote, {
                                    "id": snapshot.data['data'][i]['notes_id']
                                        .toString(),
                                    "imagename": snapshot.data['data'][i]
                                            ['notes_image']
                                        .toString()
                                  });
                                  if (response["status"] == "success") {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, 'homepage', (route) => false);
                                  }
                                },
                                btnCancelOnPress: () {},
                              ).show();
                            });
                      });
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LinearProgressIndicator());
                }
                return const Center(child: Text('Loading...'));
              })
        ]),
      ),
    );
  }
}
