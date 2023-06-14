/*
  Created by Jacob Rogers
  Last updated 4/29/2023
*/

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:adam_app/game_screens.dart';
import 'package:adam_app/tools.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';

main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ItemAdapter());
  DBs().openBoxes(true);
  Future.delayed(const Duration(seconds: 1));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ADAM',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          colorScheme:
              ColorScheme.fromSwatch(backgroundColor: Colors.blueGrey[900]),
          canvasColor: Colors.grey[900]),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Home(),
        '/m1': (context) => const Metroid(),
        '/m2': (context) => const MetroidII(),
        '/sm': (context) => const SuperMetroid(),
        '/mf': (context) => const Fusion(),
        '/zm': (context) => const ZeroMission(),
        '/om': (context) => const OtherM(),
        '/sr': (context) => const SamusReturns(),
        '/md': (context) => const Dread(),
        '/p1': (context) => const Prime(),
        '/p2': (context) => const Prime2(),
        '/p3': (context) => const Prime3(),
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  /*await Hive.openBox(box);
    var mBox = Hive.box(box);
    print(await Hive.box(box).get('Missile Expansion 29').fromInstance()); RETRIEVE METHOD*/

  Widget buttonBuilder(String name, String imageURL, String route, context) {
    return TextButton(
        onPressed: () => {Navigator.pushNamed(context, route)},
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRect(
              child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(imageURL), fit: BoxFit.cover)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4.5, sigmaY: 4.5),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    ),
                  )),
            ),
            AutoSizeText(
              name,
              textAlign: TextAlign.center,
              maxLines: 3,
              wrapWords: false,
              style: const TextStyle(
                  color: Colors.white, fontFamily: "Serpentine", fontSize: 36),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Home"),
        ),
        body: SafeArea(
            child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: <Widget>[
              buttonBuilder(
                  "Metroid",
                  "https://upload.wikimedia.org/wikipedia/en/5/5d/Metroid_boxart.jpg",
                  "/m1",
                  context),
              buttonBuilder(
                  "Metroid II",
                  "https://assets1.ignimgs.com/2019/09/05/metroid-2---button-1567645379515.jpg",
                  "/m2",
                  context),
              buttonBuilder(
                  "Super\nMetroid",
                  "https://assets-prd.ignimgs.com/2021/12/07/supermetroid-1638920229201.jpg",
                  "/sm",
                  context),
              buttonBuilder(
                  "Metroid\nFusion",
                  "https://upload.wikimedia.org/wikipedia/en/4/45/Metroid_Fusion_box.jpg",
                  "/mf",
                  context),
              buttonBuilder(
                  "Metroid\nPrime",
                  "https://assets-prd.ignimgs.com/2023/02/08/primeremastered-1675898126498.jpg",
                  "/p1",
                  context),
              buttonBuilder(
                  "Metroid:\nZero Mission",
                  "https://static.wikia.nocookie.net/metroid/images/2/28/Metroid-zero-mission-cover-artwork-gba.jpg/revision/latest?cb=20210824090139",
                  "/zm",
                  context),
              buttonBuilder(
                  "Metroid\n Prime 2:\nEchoes",
                  "https://upload.wikimedia.org/wikipedia/en/6/6e/Echoesboxart_%28Large%29.jpg",
                  "/p2",
                  context),
              buttonBuilder(
                  "Metroid\nPrime 3:\nCorruption",
                  "https://assets1.ignimgs.com/2019/09/05/metroid-prime-3-button-v2-1567645379606.jpg",
                  "/p3",
                  context),
              buttonBuilder(
                  "Metroid:\nOther M",
                  "https://upload.wikimedia.org/wikipedia/en/thumb/6/6f/Metroid_Other_M_Cover.jpg/220px-Metroid_Other_M_Cover.jpg",
                  "/om",
                  context),
              buttonBuilder(
                  "Metroid:\nSamus Returns",
                  "https://assets-prd.ignimgs.com/2022/01/08/metroid-samus-returns-button-1641602768556.jpg",
                  "/sr",
                  context),
              buttonBuilder(
                  "Metroid Dread",
                  "https://assets-prd.ignimgs.com/2021/06/16/metroid-dread-button-1623828978724.jpg",
                  "/md",
                  context)
            ])));
  }
}
