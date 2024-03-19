import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multilingual_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FIREBASE INIT
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multilingual App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _welcomeMessage;
  String? lang;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getEvents();
    // print('Welcome : ${_welcomeMessage ?? "null"}');
  }

  Future _fetchData() async {
    loading = true;
    await FirebaseFirestore.instance
        .collection('descriptions')
        .doc(selectedDocId)
        .get()
        .then((value) {
      setState(() {
        _welcomeMessage = value.data()!['text'];
        loading = false;
      });
    });
  }

  List<String> events = [];
  String? selectedDocId;

  getEvents() async {
    await FirebaseFirestore.instance
        .collection('descriptions')
        .get()
        .then((value) {
      value.docChanges.length;
      if (kDebugMode) {
        print("Number of Documents in the collection : ${value.docs.length}");
      }
      for (int i = 0; i < value.docs.length; i++) {
        var list = value.docs[i];
        if (kDebugMode) {
          print(list.id);
        }
        events.add(list.id);
      }

      setState(() {});

      if (kDebugMode) {
        print(events);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multilingual App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          const Row(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            width: 300,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30)),
            child: DropdownButton<String>(
              value: selectedDocId,
              onChanged: (value) {
                setState(() {
                  selectedDocId = value!;
                  _fetchData();
                });
                debugPrint("You selected $selectedDocId");
              },
              hint: const Center(
                  child: Text(
                'Languages',
                style: TextStyle(color: Colors.white),
              )),
              underline: Container(),
              dropdownColor: Colors.orange[200],
              icon: const Icon(
                Icons.arrow_downward,
                color: Colors.white,
              ),
              isExpanded: true,
              items: events
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            e,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ))
                  .toList(),
              selectedItemBuilder: (BuildContext context) => events
                  .map((e) => Center(
                        child: Text(
                          e,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          !loading ? Container() : const CircularProgressIndicator(),
          _welcomeMessage != null
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    _welcomeMessage!,
                    style: const TextStyle(fontSize: 20),
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Select any Language',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
        ],
      ),
    );
  }
}
