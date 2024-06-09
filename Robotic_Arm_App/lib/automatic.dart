import 'dart:convert';
import 'dart:ffi';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'home.dart';

class AutomaticPage extends StatefulWidget {
  const AutomaticPage({super.key});

  @override
  State<AutomaticPage> createState() => _AutomaticPageState();
}

class _AutomaticPageState extends State<AutomaticPage> {
  final firebaseRef = FirebaseDatabase(
          databaseURL:
              "https://zebrot-2577d-default-rtdb.europe-west1.firebasedatabase.app")
      .ref();
  DatabaseReference dbRef = FirebaseDatabase(
          databaseURL:
              "https://zebrot-2577d-default-rtdb.europe-west1.firebasedatabase.app")
      .ref();

  List<int> x_values = [];
  List<int> y_values = [];
  List<int> z_values = [];
  Map datamap = {};

  @override
  void initState() {
    super.initState();
    Stream<DatabaseEvent> stream = dbRef.onValue;
    stream.listen((DatabaseEvent event) {
      updateInfo(event.snapshot.children);
    });
  }

  void updateInfo(data) {
    setState(() {
      datamap.clear();
      data.forEach((child) {
        datamap[child.key] = child.value;
      });
    });
  }

  /*void load_data() {
    datamap.forEach((programName, programData) {
      programData.forEach((positionName, positionData) {
        print(positionData['X']);
      });
    });
  }*/

  Future delete_program(int index) async {
    var programAtIndex = datamap.entries.elementAt(index);
    var programName = programAtIndex.key;
    var programData = programAtIndex.value;
    print(programName);

    DatabaseReference dbRef = firebaseRef.child(programName.toString());
    await dbRef.remove();
    print("ola");
  }

  void load_data(int index) {
    if (index >= 0 && index < datamap.length) {
      var programAtIndex = datamap.entries.elementAt(index);
      var programName = programAtIndex.key;
      var programData = programAtIndex.value;

      programData.forEach((positionName, positionData) {
        String temp =
            "${positionData['X']} ${positionData['Y']} ${positionData['Z']}\n";
        _sendData(temp);
      });
    } else {
      print('Index out of range.');
    }
  }

  void _sendData(String temp) async {
    if (connection != null && connection!.isConnected) {
      connection!.output.add(ascii.encode(temp));
      await connection!.output.allSent;
    }
  }

  void Regist_Program() {
    DatabaseReference dbRef = firebaseRef;

    int prog_counter = datamap.keys.length;
    print(prog_counter);
    if (x_values.isNotEmpty) {
      for (int j = 0; j < x_values.length; j++) {
        DatabaseReference ref2 =
            dbRef.child("Program ${prog_counter + 1}").child("Posicion ${j}");
        ref2.set({
          "X": x_values[j],
          "Y": y_values[j],
          "Z": z_values[j],
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEEF1F8),
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "AUTOMATIC PROGRAMS",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                      ),
                    ),
                    ListView.builder(
                        clipBehavior: Clip.none,
                        //controller: _scrollController1,
                        physics: NeverScrollableScrollPhysics(),
                        //padding: EdgeInsets.only(/*top: 5, bottom: 35.0*/),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: datamap.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Stack(
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Row(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10, right: 0),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      child: Text(
                                                        "${datamap.entries.elementAt(index).key}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0),
                                                    child: GestureDetector(
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.13,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.13,
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 66, 66, 66),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color:
                                                                    Colors.grey,
                                                                blurRadius: 30,
                                                                offset: Offset(
                                                                    0, 10))
                                                          ],
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        child: Icon(
                                                          size: 30,
                                                          Icons.send,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          load_data(index);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: GestureDetector(
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.13,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.13,
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 66, 66, 66),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color:
                                                                    Colors.grey,
                                                                blurRadius: 30,
                                                                offset: Offset(
                                                                    0, 10))
                                                          ],
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        child: Icon(
                                                          size: 30,
                                                          Icons.delete_forever,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          delete_program(index);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: GestureDetector(
                        onTap: () {
                          print("MV");
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 66, 66, 66),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  size: 30,
                                  Icons.remove_red_eye_rounded,
                                  color: Colors.white,
                                ),
                                Text(
                                  " Vision Mode",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ))),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: GestureDetector(
                        onTap: () {
                          print("START");
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  size: 30,
                                  Icons.start,
                                  color: Colors.white,
                                ),
                                Text(
                                  "START",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ))),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: GestureDetector(
                        onTap: () {
                          print("STOP");
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  size: 30,
                                  Icons.stop,
                                  color: Colors.white,
                                ),
                                Text(
                                  "STOP",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ))),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: SafeArea(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (() {
                    Navigator.pop(context);
                  }),
                  child: Container(
                    //margin: const EdgeInsets.only(left: 16),
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 3),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
