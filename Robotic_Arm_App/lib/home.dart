import 'package:flutter/material.dart';

import 'dart:async';

import 'package:neeicum/manual.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController1 = ScrollController();
  Map datamap = {};
  Map mainData = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double minScrollExtent = _scrollController1.position.minScrollExtent;
      double maxScrollExtent = _scrollController1.position.maxScrollExtent;

      animateToMaxMin(maxScrollExtent, minScrollExtent, maxScrollExtent, 10,
          _scrollController1);
    });
  }

  animateToMaxMin(double max, double min, double direction, int seconds,
      ScrollController scrollController) {
    scrollController
        .animateTo(direction,
            duration: Duration(seconds: seconds), curve: Curves.linear)
        .then((value) {
      direction = direction == max ? min : max;
      animateToMaxMin(max, min, direction, seconds, scrollController);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Defina um fator de escala com base na largura ou altura da tela, conforme preferir.
    double scaleFactor =
        screenWidth > screenHeight ? screenHeight / 5 : screenWidth / 5;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 20),
                        child: Image.asset("assets/images/Zebrot.png"),
                      ),

                      /*Text(
                        "TEAM",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: scaleFactor / 3),
                      ),*/
                    ],
                  ),
                ),
              ),
              /*Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Text(
                  "Equipa",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: scaleFactor / 3),
                ),
              ),*/
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Constituintes",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: scaleFactor / 3),
                ),
              ),
              Container(
                height: 150,
                child: ListView.builder(
                    clipBehavior: Clip.none,
                    controller: _scrollController1,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(/*top: 5, bottom: 35.0*/),
                    scrollDirection: Axis.horizontal,
                    //shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 24),
                                    height: 110,
                                    width: 110,
                                    decoration: const BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 66, 66, 66),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 30,
                                            offset: Offset(0, 10))
                                      ],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0.0, vertical: 0),
                                        child: Image.asset(
                                            "assets/images/logo_w.png"),
                                      ),
                                    )),
                              ),
                              Text("Rui")
                            ],
                          ));
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Programas",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: scaleFactor / 3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManualPage()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.13,
                                      width: MediaQuery.of(context).size.width *
                                          0.13,
                                      padding: EdgeInsets.all(0),
                                      child: Icon(
                                        size: 40,
                                        Icons.electric_bolt_outlined,
                                        color: Color.fromARGB(255, 66, 66, 66),
                                      ),
                                      /*decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color:
                                                                    Colors.grey,
                                                                blurRadius: 15,
                                                                offset: Offset(
                                                                    0, 7.5))
                                                          ],
                                                          color: Color.fromARGB(
                                                              255, 66, 66, 66),
                                                          /*border: Border.all(
                                              color: Color.fromARGB(255, 66, 66, 66), // Border color
                                              width: 2.0, // Border width
                                                                        )*/
                                                          /*borderRadius: const BorderRadius.all(
                                                                        Radius.circular(20),
                                                              ),*/
                                                        ),*/
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 30),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: Text(
                                        "Manual",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.13,
                                      width: MediaQuery.of(context).size.width *
                                          0.13,
                                      padding: EdgeInsets.all(0),
                                      child: Icon(
                                        size: 40,
                                        Icons.electric_bolt_outlined,
                                        color: Color.fromARGB(255, 66, 66, 66),
                                      ),
                                      /*decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color:
                                                                    Colors.grey,
                                                                blurRadius: 15,
                                                                offset: Offset(
                                                                    0, 7.5))
                                                          ],
                                                          color: Color.fromARGB(
                                                              255, 66, 66, 66),
                                                          /*border: Border.all(
                                              color: Color.fromARGB(255, 66, 66, 66), // Border color
                                              width: 2.0, // Border width
                                                                        )*/
                                                          /*borderRadius: const BorderRadius.all(
                                                                        Radius.circular(20),
                                                              ),*/
                                                        ),*/
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 30),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: Text(
                                        "Computer Vision",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.13,
                                      width: MediaQuery.of(context).size.width *
                                          0.13,
                                      padding: EdgeInsets.all(0),
                                      child: Icon(
                                        size: 40,
                                        Icons.electric_bolt_outlined,
                                        color: Color.fromARGB(255, 66, 66, 66),
                                      ),
                                      /*decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color:
                                                                    Colors.grey,
                                                                blurRadius: 15,
                                                                offset: Offset(
                                                                    0, 7.5))
                                                          ],
                                                          color: Color.fromARGB(
                                                              255, 66, 66, 66),
                                                          /*border: Border.all(
                                              color: Color.fromARGB(255, 66, 66, 66), // Border color
                                              width: 2.0, // Border width
                                                                        )*/
                                                          /*borderRadius: const BorderRadius.all(
                                                                        Radius.circular(20),
                                                              ),*/
                                                        ),*/
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 30),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: Text(
                                        "Informations",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                ],
                              ),
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
    );
  }
}
