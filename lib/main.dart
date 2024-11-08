import 'dart:core';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'story_plan.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

late Box<DecisionMap> box;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); //HIVE SETUP
  Hive.registerAdapter(DecisionMapAdapter());
  box = await Hive.openBox<DecisionMap>('decisionMap');
  String csv = "assets/story_plan.csv"; //path to csv file asset
  String fileData = await rootBundle.loadString(csv);
  //delimiter
  List<String> rows = fileData.split("\n");
  for (int i = 0; i < rows.length; i++) {
    //selects an item from row and places
    String row = rows[i];
    List<String> itemInRow = row.split(",");
    //Code to map item to the DecisionMap object
    DecisionMap decMap = DecisionMap()
      ..idID = int.parse(itemInRow[0])
      ..yesID = int.parse(itemInRow[1])
      ..noID = int.parse(itemInRow[2])
      ..description = itemInRow[3]
      ..question = itemInRow[4];

    int key = int.parse(itemInRow[0]);
    box.put(key, decMap);
  }

  runApp(
    const MaterialApp(
      home: MyFlutterApp(),
    ),
  );
} //flutter entry point

class MyFlutterApp extends StatefulWidget {
  const MyFlutterApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyFlutterState();
  }
} //defines as an extension of the statefulWidget

class MyFlutterState extends State<MyFlutterApp> {
  late int idID;
  late int yesID;
  late int noID;
  String description = "";
  String question = "";

  @override
  void initState() {
    super.initState();
    //PLACE CODE HERE TO INITIALISE SERVER OBJECTS
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        //PLACE CODE HERE YOU WANT TO EXECUTE IMMEDIATELY AFTER
        //THE UI IS BUILT
        DecisionMap? current = box.get(0) as DecisionMap;
        idID = current.idID;
        yesID = current.yesID;
        noID = current.noID;
        description = current.description;
        question = current.question;
      });
    });
  }

  void clickHandlerYes() {
    setState(() {
      DecisionMap? current = box.get(yesID);
      if (current != null) {
        idID = current.idID;
        yesID = current.yesID;
        noID = current.noID;
        description = current.description;
        question = current.question;
      }
    });
  }

  void clickHandlerNo() {
    setState(() {
      DecisionMap? current = box.get(noID);
      if (current != null) {
        idID = current.idID;
        noID = current.noID;
        yesID = current.yesID;
        description = current.description;
        question = current.question;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Flutter UI Widgets go here
      //Makes Background color
      backgroundColor: Color.fromARGB(172, 39, 3, 73),
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                height: 1000,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/aldebaran_space.jpg"),
                      fit: BoxFit.cover),
                ),
              ),
              //Makes Button for YES
              Align(
                alignment: const Alignment(0.3, 0.3),
                child: MaterialButton(
                  onPressed: () {
                    clickHandlerYes();
                  },
                  color: Color.fromARGB(193, 26, 201, 3),
                  elevation: 10,
                  shape: const CircleBorder(),
                  textColor: const Color(0xfffffdfd),
                  padding: EdgeInsets.all(25),
                  child: const Text(
                    "YES",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
              //Makes Button for NO
              Align(
                alignment: const Alignment(-0.3, 0.3),
                child: MaterialButton(
                  onPressed: () {
                    clickHandlerNo();
                  },
                  color: Color.fromARGB(181, 197, 3, 3),
                  elevation: 10,
                  shape: const CircleBorder(),
                  textColor: const Color(0xfffffdfd),
                  padding: EdgeInsets.all(25),
                  child: const Text(
                    "NO",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
              //Makes text box for description
              Align(
                alignment: const Alignment(0.0, -0.7),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 25,
                    color: Color(0xffffffff),
                  ),
                ),
              ),

              //Makes second text box for questions
              Align(
                alignment: const Alignment(0.0, -0.2),
                child: Text(
                  question,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 25,
                    color: Color(0xffffffff),
                  ),
                ),
              ),
            ], //children end
          ),
        ),
      ),
    );
  }
}
