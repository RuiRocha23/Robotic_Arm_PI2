import 'dart:convert';
import 'dart:ffi';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'home.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class Axes {
  String type;
  int current;
  int max;
  int min;

  Axes(this.type, this.current, this.max, this.min);
}

class ManualPage extends StatefulWidget {
  const ManualPage({super.key});

  @override
  State<ManualPage> createState() => _ManualPageState();
}

class _ManualPageState extends State<ManualPage> {
  final firebaseRef = FirebaseDatabase(
          databaseURL:
              "https://zebrot-2577d-default-rtdb.europe-west1.firebasedatabase.app")
      .ref();
  DatabaseReference dbRef = FirebaseDatabase(
          databaseURL:
              "https://zebrot-2577d-default-rtdb.europe-west1.firebasedatabase.app")
      .ref();
  bool isPressed = false;
  Timer? timer;
  List<int> x_values = [];
  List<int> y_values = [];
  List<int> z_values = [];
  List<int> g_values = [];
  Map datamap = {};
  int grip = 0;
  List<Axes> Axle = [
    Axes("X", 0, 300, -5),
    Axes("Y", 0, 300, -5),
    Axes("Z", 0, 300, -5),
  ];

  @override
  void initState() {
    super.initState();
    Stream<DatabaseEvent> stream = dbRef.onValue;
    stream.listen((DatabaseEvent event) {
      updateInfo(event.snapshot.children);
    });
  }

  void _sendData() async {
    if (connection != null && connection!.isConnected) {
      String temp =
          "${grip} ${Axle[0].current} ${Axle[1].current} ${Axle[2].current}\n";
      connection!.output.add(ascii.encode(temp));
      print(connection);
      await connection!.output.allSent;
    }
  }

  void updateInfo(data) {
    setState(() {
      datamap.clear();
      data.forEach((child) {
        datamap[child.key] = child.value;
      });
    });
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
          "G": g_values[j]
        });
      }
    }
  }

  void addValues() {
    setState(() {
      x_values.add(Axle[0].current);
      y_values.add(Axle[1].current);
      z_values.add(Axle[2].current);
      g_values.add(grip);
    });
  }

  void ClearValues() {
    setState(() {
      x_values.clear();
      y_values.clear();
      z_values.clear();
      g_values.clear();
    });
  }

  void idle() {}

  void showLimitExceededSnackbar(BuildContext context, String feedback) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.orange,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.save,
              size: 32, // Adjust the size of the icon as needed.
              color: Colors.white, // Adjust the icon color as needed.
            ),
            SizedBox(width: 10), // Add some spacing between the icon and text.
            Text(
              feedback,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18, // Adjust the font size of the text as needed.
              ),
            ),
          ],
        ),
        duration: Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), // Adjust the border radius as needed.
            topRight:
                Radius.circular(20), // Adjust the border radius as needed.
          ),
        ), // Adjust the duration as needed.
      ),
    );
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
                        "MANUAL CONTROL",
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
                        itemCount: Axle.length,
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
                                                        left: 10, right: 30),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.29,
                                                      child: Text(
                                                        "Axle ${Axle[index].type}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        child: Text(
                                                          "${Axle[index].current}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
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
                                                          Icons.add,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          if (Axle[index]
                                                                  .current <
                                                              Axle[index].max) {
                                                            Axle[index]
                                                                .current++;
                                                            String temp =
                                                                "${Axle[index].type} ${Axle[index].current}";
                                                            print(temp);
                                                            _sendData();
                                                          }
                                                        });
                                                      },
                                                      onLongPressStart:
                                                          (detail) {
                                                        setState(() {
                                                          timer = Timer.periodic(
                                                              const Duration(
                                                                  milliseconds:
                                                                      100),
                                                              (t) {
                                                            setState(() {
                                                              if (Axle[index]
                                                                      .current <
                                                                  Axle[index]
                                                                      .max) {
                                                                Axle[index]
                                                                    .current++;
                                                                String temp =
                                                                    "${Axle[index].type} ${Axle[index].current}";
                                                                print(temp);
                                                                _sendData();
                                                              }
                                                            });
                                                          });
                                                        });
                                                      },
                                                      onLongPressEnd: (detail) {
                                                        if (timer != null) {
                                                          timer!.cancel();
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          if (Axle[index]
                                                                  .current >
                                                              Axle[index].min) {
                                                            Axle[index]
                                                                .current--;
                                                            String temp =
                                                                "${Axle[index].type} ${Axle[index].current}";
                                                            _sendData();
                                                            print(temp);
                                                          }
                                                        });
                                                      },
                                                      onLongPressStart:
                                                          (detail) {
                                                        setState(() {
                                                          timer = Timer.periodic(
                                                              const Duration(
                                                                  milliseconds:
                                                                      100),
                                                              (t) {
                                                            setState(() {
                                                              if (Axle[index]
                                                                      .current >
                                                                  Axle[index]
                                                                      .min) {
                                                                Axle[index]
                                                                    .current--;
                                                                String temp =
                                                                    "${Axle[index].type} ${Axle[index].current}";
                                                                _sendData();
                                                                print(temp);
                                                              }
                                                            });
                                                          });
                                                        });
                                                      },
                                                      onLongPressEnd: (detail) {
                                                        if (timer != null) {
                                                          timer!.cancel();
                                                        }
                                                      },
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
                                                          Icons.remove,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
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
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 30),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.425,
                                                child: Text(
                                                  "Grip",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            LiteRollingSwitch(
                                              width: 118,
                                              value: false,
                                              textOn: "On",
                                              textOff: "Off",
                                              colorOn: Colors.green,
                                              colorOff: Colors.red,
                                              iconOn: Icons.done,
                                              iconOff: Icons.offline_bolt,
                                              textSize: 18,
                                              onChanged: (bool position) {
                                                setState(() {
                                                  if (position) {
                                                    grip = 1;
                                                  } else {
                                                    grip = 0;
                                                  }
                                                  _sendData();
                                                });
                                              },
                                              onTap: idle,
                                              onDoubleTap: idle,
                                              onSwipe: idle,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          child: GestureDetector(
                            onTap: () {
                              addValues();
                              print(x_values);
                              showLimitExceededSnackbar(
                                  context, 'Position Saved');
                            },
                            child: Container(
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 30,
                              height: MediaQuery.of(context).size.width * 0.2,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 30,
                                      offset: Offset(0, 10))
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10, right: 30),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                    child: Text(
                                                      "Save\nPosition",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 20, top: 20),
                          child: GestureDetector(
                            onTap: () {
                              Regist_Program();
                              ClearValues();
                              showLimitExceededSnackbar(
                                  context, 'Program Saved');
                            },
                            child: Container(
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 30,
                              height: MediaQuery.of(context).size.width * 0.2,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 66, 66, 66),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 30,
                                      offset: Offset(0, 10))
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10, right: 30),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                    child: Center(
                                                      child: Text(
                                                        "Save\nProgram",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 20),
                      child: GestureDetector(
                        onTap: () {
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BluetoothScreen()),
                          );*/
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 30,
                                  offset: Offset(0, 10))
                            ],
                          ),
                          child: Stack(
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 30),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Text(
                                                  "Configurations",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
