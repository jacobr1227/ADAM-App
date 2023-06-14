import 'package:flutter/material.dart';
import 'package:adam_app/tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';

Widget mapImageBuilder(String url, String tag, context) {
  return Container(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: GestureDetector(
          child: Hero(
            tag: tag,
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                  child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator())),
            ),
          ),
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetailScreen(tag: tag, url: url);
              }))));
}

void retrieveBox(String game) async {
  await Hive.openBox(game);
}

void listResetButton(String game) async {
  retrieveBox(game);
  await Hive.box(game).clear();
  DBs().openBoxes(true);
}

class Metroid extends StatefulWidget {
  const Metroid({super.key});
  @override
  State<Metroid> createState() => _MetroidState();
}

class _MetroidState extends State<Metroid> {
  static final List<String> url = [
    "http://www.metroid-database.com/wp-content/uploads/Metroid/Metroid_danidub.png",
    "http://www.metroid-database.com/wp-content/uploads/Metroid/m1map_scnsht.png",
    "http://www.metroid-database.com/wp-content/uploads/Metroid/metmap4.jpg"
  ];
  static final List<String> tag = ['1m1', '1m2', '1m3'];
  List<dynamic> boxToList = [];
  List<String> itemList = [
    "Morph Ball",
    "Bombs",
    "Long Beam",
    "Ice Beam",
    "Varia Suit",
    "High Jump Boots",
    "Screw Attack",
    "Wave Beam"
  ];
  var mb = Hive.box('Metroid');
  String dropdownSelection = "Missiles";
  @override
  Widget build(BuildContext context) {
    if (!Hive.box('Metroid').isOpen) {
      retrieveBox('Metroid');
    }
    setState(() {
      for (int i = 0; i < mb.length; i++) {
        boxToList.add(mb.getAt(i).fromInstance());
      }
    });
    //ensures the box is open across the different screens (because sometimes it closes...)
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Metroid"),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height / 3,
                  alignment: Alignment.center,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      mapImageBuilder(url[0], tag[0], context),
                      mapImageBuilder(url[1], tag[1], context),
                      mapImageBuilder(url[2], tag[2], context)
                    ],
                  )),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
                        child: ElevatedButton(
                            onPressed: () {
                              listResetButton('Metroid');
                              boxToList.clear();
                              setState(() {
                                for (int i = 0; i < mb.length; i++) {
                                  boxToList.add(mb.getAt(i).fromInstance());
                                }
                              });
                            },
                            child: const Text("Reset"))),
                    DropdownButton(
                        underline: const DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 1.0))),
                        ),
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.grey[600],
                        hint: Text(dropdownSelection,
                            style: const TextStyle(color: Colors.white)),
                        items: const [
                          DropdownMenuItem(
                              value: "Missiles",
                              child: Text("Missiles",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Energy Tank",
                              child: Text("Energy Tanks",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Other Gear",
                              child: Text("Other Gear",
                                  style: TextStyle(color: Colors.white)))
                        ],
                        onChanged: (String? value) => setState(() {
                              dropdownSelection = value!;
                            })),
                    Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                        child: ElevatedButton(
                            child: const Text("Share"),
                            onPressed: () {
                              int percentage = 0;
                              for (int i = 0; i < mb.length; i++) {
                                if (mb.getAt(i).fromInstance()[3] == true) {
                                  percentage++;
                                }
                              }
                              percentage =
                                  ((percentage / mb.length) * 100).round();
                              Share.share(
                                  'I\'ve completed $percentage% of Metroid I! Check out the app at github.com/jrogers15/adam_app once it\'s available!');
                            })),
                  ]), //share button

              dropdownSelection == "Other Gear"
                  ? ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][0] == itemList[index]) {
                            itemData = boxToList[i];
                          }
                        }
                        return Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1))),
                            child: CheckboxListTile(
                              title: itemData[3]
                                  ? RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                              color: Colors.blue[300],
                                              decoration:
                                                  TextDecoration.lineThrough),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough))
                                        ]))
                                  : RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                            color: Colors.lightBlue[300],
                                          ),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ))
                                        ])),
                              value: itemData[3],
                              onChanged: (value) {
                                value == true
                                    ? {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: true)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = true;
                                            }
                                          }
                                        })
                                      }
                                    : {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: false)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = false;
                                            }
                                          }
                                        })
                                      };
                              },
                            ));
                      }))
                  : ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: boxToList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][1] == index &&
                              boxToList[i][0] == "$dropdownSelection $index") {
                            itemData = boxToList[i];
                          }
                        }
                        if (mb.get("$dropdownSelection $index") != null) {
                          return Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: CheckboxListTile(
                                title: itemData[3]
                                    ? RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                                color: Colors.blue[300],
                                                decoration:
                                                    TextDecoration.lineThrough),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough))
                                          ]))
                                    : RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                              color: Colors.lightBlue[300],
                                            ),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.white))
                                          ])),
                                value: itemData[3],
                                onChanged: (value) {
                                  value == true
                                      ? {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: true)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = true;
                                              }
                                            }
                                          })
                                        }
                                      : {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: false)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = false;
                                              }
                                            }
                                          })
                                        };
                                },
                              ));
                        } else {
                          return Container();
                        }
                      })),
              const SizedBox(height: 30)
            ])));
  }
}

class MetroidII extends StatefulWidget {
  const MetroidII({super.key});
  @override
  State<MetroidII> createState() => _MetroidIIState();
}

class _MetroidIIState extends State<MetroidII> {
  static final List<String> url = [
    "http://www.metroid-database.com/wp-content/uploads/Metroid-2-Return-of-Samus/m2map2.jpg",
    "http://www.metroid-database.com/wp-content/uploads/Metroid-2-Return-of-Samus/met2_map_monnens.gif",
    "http://www.metroid-database.com/wp-content/uploads/Metroid-2-Return-of-Samus/Metroid2-SR388-Map-labeled_grauken.png",
    "http://www.metroid-database.com/wp-content/uploads/Metroid-2-Return-of-Samus/m2map3.png",
    "http://www.metroid-database.com/wp-content/uploads/Metroid-2-Return-of-Samus/M2_map_nolanpflug.png"
  ];
  static final List<String> tag = ['2m1', '2m2', '2m3', '2m4', '2m5'];
  List<dynamic> boxToList = [];
  List<String> itemList = [
    "Bombs",
    "Ice Beam",
    "Spider Ball",
    "Varia Suit",
    "Wave Beam",
    "High Jump Boots",
    "Spring Ball",
    "Space Jump",
    "Spazer Beam",
    "Plasma Beam",
    "Screw Attack",
  ];
  var mb = Hive.box('MetroidII');
  String dropdownSelection = "Missiles";
  @override
  Widget build(BuildContext context) {
    if (!Hive.box('MetroidII').isOpen) {
      retrieveBox('MetroidII');
    }
    setState(() {
      for (int i = 0; i < mb.length; i++) {
        boxToList.add(mb.getAt(i).fromInstance());
      }
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Metroid II"),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height / 3,
                  alignment: Alignment.center,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      mapImageBuilder(url[0], tag[0], context),
                      mapImageBuilder(url[1], tag[1], context),
                      mapImageBuilder(url[2], tag[2], context),
                      mapImageBuilder(url[3], tag[3], context),
                      mapImageBuilder(url[4], tag[4], context),
                    ],
                  )),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
                        child: ElevatedButton(
                            onPressed: () {
                              listResetButton('MetroidII');
                              boxToList.clear();
                              setState(() {
                                for (int i = 0; i < mb.length; i++) {
                                  boxToList.add(mb.getAt(i).fromInstance());
                                }
                              });
                            },
                            child: const Text("Reset"))),
                    DropdownButton(
                        underline: const DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 1.0))),
                        ),
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.grey[600],
                        hint: Text(dropdownSelection,
                            style: const TextStyle(color: Colors.white)),
                        items: const [
                          DropdownMenuItem(
                              value: "Missiles",
                              child: Text("Missiles",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Energy Tank",
                              child: Text("Energy Tanks",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Other Gear",
                              child: Text("Other Gear",
                                  style: TextStyle(color: Colors.white))),
                        ],
                        onChanged: (String? value) => setState(() {
                              dropdownSelection = value!;
                            })),
                    Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                        child: ElevatedButton(
                            child: const Text("Share"),
                            onPressed: () {
                              int percentage = 0;
                              for (int i = 0; i < mb.length; i++) {
                                if (mb.getAt(i).fromInstance()[3] == true) {
                                  percentage++;
                                }
                              }
                              percentage =
                                  ((percentage / mb.length) * 100).round();
                              Share.share(
                                  'I\'ve completed $percentage% of Metroid II! Check out the app at github.com/jrogers15/adam_app once it\'s available!');
                            })),
                  ]), //share button

              dropdownSelection == "Other Gear"
                  ? ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][0] == itemList[index]) {
                            itemData = boxToList[i];
                          }
                        }
                        return Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1))),
                            child: CheckboxListTile(
                              title: itemData[3]
                                  ? RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                              color: Colors.blue[300],
                                              decoration:
                                                  TextDecoration.lineThrough),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough))
                                        ]))
                                  : RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                            color: Colors.lightBlue[300],
                                          ),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ))
                                        ])),
                              value: itemData[3],
                              onChanged: (value) {
                                value == true
                                    ? {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: true)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = true;
                                            }
                                          }
                                        })
                                      }
                                    : {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: false)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = false;
                                            }
                                          }
                                        })
                                      };
                              },
                            ));
                      }))
                  : ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: boxToList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][1] == index &&
                              boxToList[i][0] == "$dropdownSelection $index") {
                            itemData = boxToList[i];
                          }
                        }
                        if (mb.get("$dropdownSelection $index") != null) {
                          return Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: CheckboxListTile(
                                title: itemData[3]
                                    ? RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                                color: Colors.blue[300],
                                                decoration:
                                                    TextDecoration.lineThrough),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough))
                                          ]))
                                    : RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                              color: Colors.lightBlue[300],
                                            ),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.white))
                                          ])),
                                value: itemData[3],
                                onChanged: (value) {
                                  value == true
                                      ? {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: true)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = true;
                                              }
                                            }
                                          })
                                        }
                                      : {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: false)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = false;
                                              }
                                            }
                                          })
                                        };
                                },
                              ));
                        } else {
                          return Container();
                        }
                      })),

              const SizedBox(height: 30)
            ])));
  }
}

class SuperMetroid extends StatefulWidget {
  const SuperMetroid({super.key});
  @override
  State<SuperMetroid> createState() => _SuperMetroidState();
}

class _SuperMetroidState extends State<SuperMetroid> {
  static final List<String> url = [
    "http://www.metroid-database.com/wp-content/uploads/Super-Metroid/smmap1.gif",
    "http://www.metroid-database.com/wp-content/uploads/Super-Metroid/SuperMetroidmap_danidub.png",
    "http://www.metroid-database.com/wp-content/uploads/Super-Metroid/smmap2.jpg",
    "http://www.metroid-database.com/wp-content/uploads/Super-Metroid/supermetroiddevmap_2000px.jpg"
  ];
  static final List<String> tag = ['3m1', '3m2', '3m3', '3m4'];
  List<dynamic> boxToList = [];
  List<String> itemList = [
    'Morph Ball',
    'Bombs',
    'Charge Beam',
    'Hi-Jump Boots',
    'Spazer Beam',
    'Varia Suit',
    'Speed Booster',
    'Ice Beam',
    'Grapple Beam',
    'X-Ray Scope',
    'Wave Beam',
    'Gravity Suit',
    'Space Jump',
    'Plasma Beam',
    'Spring Ball',
    'Screw Attack',
  ];
  List<String> areaList = [
    'Crateria',
    'Brinstar',
    'Norfair',
    'Wrecked Ship',
    'Maridia'
  ];
  List<bool> areaTitled = [false, false, false, false, false];
  var mb = Hive.box('SuperMetroid');
  String dropdownSelection = "Missiles";
  @override
  Widget build(BuildContext context) {
    if (!Hive.box('SuperMetroid').isOpen) {
      retrieveBox('SuperMetroid');
    }
    setState(() {
      for (int i = 0; i < mb.length; i++) {
        boxToList.add(mb.getAt(i).fromInstance());
      }
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Super Metroid"),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height / 3,
                  alignment: Alignment.center,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      mapImageBuilder(url[0], tag[0], context),
                      mapImageBuilder(url[1], tag[1], context),
                      mapImageBuilder(url[2], tag[2], context),
                      mapImageBuilder(url[3], tag[3], context)
                    ],
                  )),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
                        child: ElevatedButton(
                            onPressed: () {
                              listResetButton('SuperMetroid');
                              boxToList.clear();
                              setState(() {
                                for (int i = 0; i < mb.length; i++) {
                                  boxToList.add(mb.getAt(i).fromInstance());
                                  areaTitled = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false
                                  ];
                                }
                              });
                            },
                            child: const Text("Reset"))),
                    DropdownButton(
                        underline: const DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 1.0))),
                        ),
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.grey[600],
                        hint: Text(dropdownSelection,
                            style: const TextStyle(color: Colors.white)),
                        items: const [
                          DropdownMenuItem(
                              value: "Missiles",
                              child: Text("Missiles",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Energy Tank",
                              child: Text("Energy Tanks",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Super Missiles",
                              child: Text("Super Missiles",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Power Bombs",
                              child: Text("Power Bombs",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Reserve Tank",
                              child: Text("Reserve Tanks",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Other Gear",
                              child: Text("Other Gear",
                                  style: TextStyle(color: Colors.white)))
                        ],
                        onChanged: (String? value) => setState(() {
                              dropdownSelection = value!;
                              areaTitled = [false, false, false, false, false];
                            })),
                    Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                        child: ElevatedButton(
                            child: const Text("Share"),
                            onPressed: () {
                              int percentage = 0;
                              for (int i = 0; i < mb.length; i++) {
                                if (mb.getAt(i).fromInstance()[3] == true) {
                                  percentage++;
                                }
                              }
                              percentage =
                                  ((percentage / mb.length) * 100).round();
                              Share.share(
                                  'I\'ve completed $percentage% of Super Metroid! Check out the app at github.com/jrogers15/adam_app once it\'s available!');
                            })),
                  ]), //share button

              dropdownSelection == "Other Gear"
                  ? ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][0] == itemList[index]) {
                            itemData = boxToList[i];
                          }
                        }
                        return Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1))),
                            child: CheckboxListTile(
                              title: itemData[3]
                                  ? RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                              color: Colors.blue[300],
                                              decoration:
                                                  TextDecoration.lineThrough),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough))
                                        ]))
                                  : RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                            color: Colors.lightBlue[300],
                                          ),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ))
                                        ])),
                              value: itemData[3],
                              onChanged: (value) {
                                value == true
                                    ? {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: true)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = true;
                                            }
                                          }
                                        })
                                      }
                                    : {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: false)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = false;
                                            }
                                          }
                                        })
                                      };
                              },
                            ));
                      }))
                  : ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: boxToList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        if (areaTitled != [false, false, false, false, false] &&
                            index <= 1) {
                          areaTitled = [false, false, false, false, false];
                        }
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][1] == index &&
                              boxToList[i][0] == "$dropdownSelection $index") {
                            itemData = boxToList[i];
                          }
                        }
                        if (areaTitled[0] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 1) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 1) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 1) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 1)) {
                          areaTitled[0] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[0],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[1] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 9) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 3) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 2) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 2) ||
                            (dropdownSelection == "Reserve Tank" &&
                                index == 1)) {
                          areaTitled[1] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[1],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[2] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 21) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 8) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 5) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 7) ||
                            (dropdownSelection == "Reserve Tank" &&
                                index == 2)) {
                          areaTitled[2] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[2],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[3] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 36) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 12) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 6) ||
                            (dropdownSelection == "Reserve Tank" &&
                                index == 3)) {
                          areaTitled[3] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[3],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[4] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 39) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 13) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 8) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 10) ||
                            (dropdownSelection == "Reserve Tank" &&
                                index == 4)) {
                          areaTitled[4] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[4],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (mb.get("$dropdownSelection $index") != null) {
                          return Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: CheckboxListTile(
                                title: itemData[3]
                                    ? RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                                color: Colors.blue[300],
                                                decoration:
                                                    TextDecoration.lineThrough),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough))
                                          ]))
                                    : RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                              color: Colors.lightBlue[300],
                                            ),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.white))
                                          ])),
                                value: itemData[3],
                                onChanged: (value) {
                                  value == true
                                      ? {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: true)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = true;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                          })
                                        }
                                      : {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: false)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = false;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                          })
                                        };
                                },
                              ));
                        } else {
                          return Container();
                        }
                      })),
              const SizedBox(height: 30)
            ])));
  }
}

class Fusion extends StatefulWidget {
  const Fusion({super.key});
  @override
  State<Fusion> createState() => _FusionState();
}

class _FusionState extends State<Fusion> {
  static final List<String> url = [
    "http://www.metroid-database.com/wp-content/uploads/Metroid-Fusion/mfmap01.gif",
    "http://www.metroid-database.com/wp-content/uploads/Metroid-Fusion/MetroidFusion2021.png",
    "http://www.metroid-database.com/wp-content/uploads/Metroid-Fusion/mfmap02.jpg"
  ];
  static final List<String> tag = ["4m1", "4m2", '4m3'];
  List<dynamic> boxToList = [];
  List<String> areaList = [
    'Main Deck',
    'Sector 1 (SRX)',
    'Sector 2 (TRO)',
    'Sector 3 (PYR)',
    'Sector 4 (AQA)',
    'Sector 5 (ARC)',
    'Sector 6 (NOC)'
  ];
  List<bool> areaTitled = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List<String> itemList = [
    'Missile Launcher',
    'Morph Ball',
    'Charge Beam',
    'Morph Ball Bombs',
    'Hi-Jump/Jumpball',
    'Speed Booster',
    'Super Missile',
    'Varia Suit',
    'Ice Missile',
    'Wide Beam',
    'Power Bomb',
    'Space Jump',
    'Plasma Beam',
    'Gravity Suit',
    'Diffusion Missile',
    'Wave Beam',
    'Screw Attack',
    'Ice Beam'
  ];
  var mb = Hive.box('Fusion');
  String dropdownSelection = "Missiles";
  @override
  Widget build(BuildContext context) {
    if (!Hive.box('Fusion').isOpen) {
      retrieveBox('Fusion');
    }
    setState(() {
      for (int i = 0; i < mb.length; i++) {
        boxToList.add(mb.getAt(i).fromInstance());
      }
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Metroid Fusion"),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height / 3,
                  alignment: Alignment.center,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      mapImageBuilder(url[0], tag[0], context),
                      mapImageBuilder(url[1], tag[1], context),
                      mapImageBuilder(url[2], tag[2], context)
                    ],
                  )),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
                        child: ElevatedButton(
                            onPressed: () {
                              listResetButton('Fusion');
                              boxToList.clear();
                              setState(() {
                                for (int i = 0; i < mb.length; i++) {
                                  boxToList.add(mb.getAt(i).fromInstance());
                                  areaTitled = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                  ];
                                }
                              });
                            },
                            child: const Text("Reset"))),
                    DropdownButton(
                        underline: const DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 1.0))),
                        ),
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.grey[600],
                        hint: Text(dropdownSelection,
                            style: const TextStyle(color: Colors.white)),
                        items: const [
                          DropdownMenuItem(
                              value: "Missiles",
                              child: Text("Missiles",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Energy Tank",
                              child: Text("Energy Tanks",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Power Bomb",
                              child: Text("Power Bombs",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Other Gear",
                              child: Text("Other Gear",
                                  style: TextStyle(color: Colors.white))),
                        ],
                        onChanged: (String? value) => setState(() {
                              dropdownSelection = value!;
                              areaTitled = [
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                              ];
                            })),
                    Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                        child: ElevatedButton(
                            child: const Text("Share"),
                            onPressed: () {
                              int percentage = 0;
                              for (int i = 0; i < mb.length; i++) {
                                if (mb.getAt(i).fromInstance()[3] == true) {
                                  percentage++;
                                }
                              }
                              percentage =
                                  ((percentage / mb.length) * 100).round();
                              Share.share(
                                  'I\'ve completed $percentage% of Metroid Fusion! Check out the app at github.com/jrogers15/adam_app once it\'s available!');
                            })),
                  ]), //share button

              dropdownSelection == "Other Gear"
                  ? ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][0] == itemList[index]) {
                            itemData = boxToList[i];
                          }
                        }
                        return Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1))),
                            child: CheckboxListTile(
                              title: itemData[3]
                                  ? RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                              color: Colors.blue[300],
                                              decoration:
                                                  TextDecoration.lineThrough),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough))
                                        ]))
                                  : RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                            color: Colors.lightBlue[300],
                                          ),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ))
                                        ])),
                              value: itemData[3],
                              onChanged: (value) {
                                value == true
                                    ? {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: true)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = true;
                                            }
                                          }
                                        })
                                      }
                                    : {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: false)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = false;
                                            }
                                          }
                                        })
                                      };
                              },
                            ));
                      }))
                  : ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: boxToList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        if (areaTitled !=
                                [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                ] &&
                            index <= 1) {
                          areaTitled = [
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                          ];
                        }
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][1] == index &&
                              boxToList[i][0] == "$dropdownSelection $index") {
                            itemData = boxToList[i];
                          }
                        }
                        if (areaTitled[0] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 1) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 1) ||
                            (dropdownSelection == "Power Bomb" && index == 1)) {
                          areaTitled[0] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[0],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[1] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 8) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 4) ||
                            (dropdownSelection == "Power Bomb" && index == 4)) {
                          areaTitled[1] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[1],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[2] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 14) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 7) ||
                            (dropdownSelection == "Power Bomb" && index == 7)) {
                          areaTitled[2] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[2],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[3] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 23) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 10) ||
                            (dropdownSelection == "Power Bomb" &&
                                index == 12)) {
                          areaTitled[3] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[3],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[4] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 30) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 13) ||
                            (dropdownSelection == "Power Bomb" &&
                                index == 18)) {
                          areaTitled[4] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[4],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[5] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 39) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 15) ||
                            (dropdownSelection == "Power Bomb" &&
                                index == 22)) {
                          areaTitled[5] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[5],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[6] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 43) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 18) ||
                            (dropdownSelection == "Power Bomb" &&
                                index == 30)) {
                          areaTitled[6] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[6],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (mb.get("$dropdownSelection $index") != null) {
                          return Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: CheckboxListTile(
                                title: itemData[3]
                                    ? RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                                color: Colors.blue[300],
                                                decoration:
                                                    TextDecoration.lineThrough),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough))
                                          ]))
                                    : RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                              color: Colors.lightBlue[300],
                                            ),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.white))
                                          ])),
                                value: itemData[3],
                                onChanged: (value) {
                                  value == true
                                      ? {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: true)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = true;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                          })
                                        }
                                      : {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: false)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = false;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                          })
                                        };
                                },
                              ));
                        } else {
                          return Container();
                        }
                      })),
              const SizedBox(height: 30)
            ])));
  }
}

class ZeroMission extends StatefulWidget {
  const ZeroMission({super.key});
  @override
  State<ZeroMission> createState() => _ZeroMissionState();
}

class _ZeroMissionState extends State<ZeroMission> {
  static final List<String> url = [
    "http://www.metroid-database.com/wp-content/uploads/MetroidZeroMission/ZeroMissionmap_danidub.png",
    "http://www.metroid-database.com/wp-content/uploads/MetroidZeroMission/mzmmap02.gif",
    "http://www.metroid-database.com/wp-content/uploads/MetroidZeroMission/mzm_map01.jpg"
  ];
  static final List<String> tag = ['5m1', '5m2', '5m3'];
  List<dynamic> boxToList = [];
  List<String> itemList = [
    'Morph Ball',
    'Long Beam',
    'Charge Beam',
    'Bombs',
    'Unknown Item #1 (Plasma Beam)',
    'Power Grip',
    'Ice Beam',
    'Unknown Item #2 (Space Jump)',
    'Speed Booster',
    'Hi-Jump Boots',
    'Varia Suit',
    'Wave Beam',
    'Unknown Item #3 (Gravity Suit)',
    'Screw Attack'
  ];
  List<String> areaList = [
    'Brinstar',
    'Crateria',
    'Norfair',
    'Kraid\'s Lair',
    'Ridley\'s Lair',
    'Tourian',
    'Chozodia'
  ];
  List<bool> areaTitled = [false, false, false, false, false, false, false];
  var mb = Hive.box('ZeroMission');
  String dropdownSelection = "Missiles";
  @override
  Widget build(BuildContext context) {
    if (!Hive.box('ZeroMission').isOpen) {
      retrieveBox('ZeroMission');
    }
    setState(() {
      for (int i = 0; i < mb.length; i++) {
        boxToList.add(mb.getAt(i).fromInstance());
      }
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Metroid: Zero Mission"),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height / 3,
                  alignment: Alignment.center,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      mapImageBuilder(url[0], tag[0], context),
                      mapImageBuilder(url[1], tag[1], context),
                      mapImageBuilder(url[2], tag[2], context)
                    ],
                  )),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
                        child: ElevatedButton(
                            onPressed: () {
                              listResetButton('ZeroMission');
                              boxToList.clear();
                              setState(() {
                                for (int i = 0; i < mb.length; i++) {
                                  boxToList.add(mb.getAt(i).fromInstance());
                                  areaTitled = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false
                                  ];
                                }
                              });
                            },
                            child: const Text("Reset"))),
                    DropdownButton(
                        underline: const DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 1.0))),
                        ),
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.grey[600],
                        hint: Text(dropdownSelection,
                            style: const TextStyle(color: Colors.white)),
                        items: const [
                          DropdownMenuItem(
                              value: "Missiles",
                              child: Text("Missiles",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Energy Tank",
                              child: Text("Energy Tanks",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Super Missiles",
                              child: Text("Super Missiles",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Power Bombs",
                              child: Text("Power Bombs",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Other Gear",
                              child: Text("Other Gear",
                                  style: TextStyle(color: Colors.white))),
                        ],
                        onChanged: (String? value) => setState(() {
                              dropdownSelection = value!;
                              areaTitled = [
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false
                              ];
                            })),
                    Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                        child: ElevatedButton(
                            child: const Text("Share"),
                            onPressed: () {
                              int percentage = 0;
                              for (int i = 0; i < mb.length; i++) {
                                if (mb.getAt(i).fromInstance()[3] == true) {
                                  percentage++;
                                }
                              }
                              percentage =
                                  ((percentage / mb.length) * 100).round();
                              Share.share(
                                  'I\'ve completed $percentage% of Metroid Zero Mission! Check out the app at github.com/jrogers15/adam_app once it\'s available!');
                            })),
                  ]), //share button

              dropdownSelection == "Other Gear"
                  ? ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][0] == itemList[index]) {
                            itemData = boxToList[i];
                          }
                        }
                        return Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1))),
                            child: CheckboxListTile(
                              title: itemData[3]
                                  ? RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                              color: Colors.blue[300],
                                              decoration:
                                                  TextDecoration.lineThrough),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough))
                                        ]))
                                  : RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                            color: Colors.lightBlue[300],
                                          ),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ))
                                        ])),
                              value: itemData[3],
                              onChanged: (value) {
                                value == true
                                    ? {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: true)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = true;
                                            }
                                          }
                                        })
                                      }
                                    : {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: false)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = false;
                                            }
                                          }
                                        })
                                      };
                              },
                            ));
                      }))
                  : ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: boxToList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        if (areaTitled !=
                                [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                ] &&
                            index <= 1) {
                          areaTitled = [
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                          ];
                        }
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][1] == index &&
                              boxToList[i][0] == "$dropdownSelection $index") {
                            itemData = boxToList[i];
                          }
                        }
                        if (areaTitled[0] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 1) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 1) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 1)) {
                          areaTitled[0] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[0],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[1] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 11) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 2) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 1)) {
                          areaTitled[1] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[1],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[2] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 14) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 5) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 3) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 2)) {
                          areaTitled[2] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[2],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[3] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 27) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 5)) {
                          areaTitled[3] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[3],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[4] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 36) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 7) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 5)) {
                          areaTitled[4] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[4],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[5] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 49) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 3)) {
                          areaTitled[5] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[5],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[6] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 50) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 10) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 8) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 4)) {
                          areaTitled[6] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[6],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (mb.get("$dropdownSelection $index") != null) {
                          return Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: CheckboxListTile(
                                title: itemData[3]
                                    ? RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                                color: Colors.blue[300],
                                                decoration:
                                                    TextDecoration.lineThrough),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough))
                                          ]))
                                    : RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                              color: Colors.lightBlue[300],
                                            ),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.white))
                                          ])),
                                value: itemData[3],
                                onChanged: (value) {
                                  value == true
                                      ? {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: true)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = true;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                          })
                                        }
                                      : {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: false)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = false;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                          })
                                        };
                                },
                              ));
                        } else {
                          return Container();
                        }
                      })),
              const SizedBox(height: 30)
            ])));
  }
}

class SamusReturns extends StatefulWidget {
  const SamusReturns({super.key});
  @override
  State<SamusReturns> createState() => _SamusReturnsState();
}

class _SamusReturnsState extends State<SamusReturns> {
  static final List<String> url = [
    "http://www.metroid-database.com/wp-content/uploads/Metroid-Samus-Returns/MSRbyAsaic-LgVer-.png",
    "http://www.metroid-database.com/wp-content/uploads/Metroid-Samus-Returns/SamusReturns.png"
  ];
  static final List<String> tag = ["6m1", "6m2"];
  List<String> itemList = [
    'Morph Ball',
    'Scan Pulse',
    'Charge Beam',
    'Bomb',
    'Ice Beam',
    'Spider Ball',
    'Lightning Armor',
    'Spring Ball',
    'Varia Suit',
    'Wave Beam',
    'High Jump Boots',
    'Burst Beam',
    'Grapple Beam',
    'Spazer Beam',
    'Space Jump',
    'Super Missile',
    'Phase Drift',
    'Plasma Beam',
    'Gravity Suit',
    'Screw Attack',
    'Power Bomb'
  ];
  List<String> areaList = [
    'Surface Area',
    'Area 1',
    'Area 2',
    'Area 3',
    'Area 4',
    'Area 5',
    'Area 6',
    'Area 7',
    'Area 8'
  ];
  List<bool> areaTitled = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<dynamic> boxToList = [];
  var mb = Hive.box('SamusReturns');
  String dropdownSelection = "Missiles";
  @override
  Widget build(BuildContext context) {
    if (!Hive.box('SamusReturns').isOpen) {
      retrieveBox('SamusReturns');
    }
    setState(() {
      for (int i = 0; i < mb.length; i++) {
        boxToList.add(mb.getAt(i).fromInstance());
      }
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Metroid: Samus Returns"),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height / 3,
                  alignment: Alignment.center,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      mapImageBuilder(url[0], tag[0], context),
                      mapImageBuilder(url[1], tag[1], context),
                    ],
                  )),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
                        child: ElevatedButton(
                            onPressed: () {
                              listResetButton('SamusReturns');
                              boxToList.clear();
                              setState(() {
                                for (int i = 0; i < mb.length; i++) {
                                  boxToList.add(mb.getAt(i).fromInstance());
                                  areaTitled = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false
                                  ];
                                }
                              });
                            },
                            child: const Text("Reset"))),
                    DropdownButton(
                        underline: const DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 1.0))),
                        ),
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.grey[600],
                        hint: Text(dropdownSelection,
                            style: const TextStyle(color: Colors.white)),
                        items: const [
                          DropdownMenuItem(
                              value: "Missiles",
                              child: Text("Missiles",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Energy Tank",
                              child: Text("Energy Tanks",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Power Bombs",
                              child: Text("Power Bombs",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Super Missiles",
                              child: Text("Super Missiles",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Aeion Tank",
                              child: Text("Aeion Tanks",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Other Gear",
                              child: Text("Other Gear",
                                  style: TextStyle(color: Colors.white))),
                        ],
                        onChanged: (String? value) => setState(() {
                              dropdownSelection = value!;
                            })),
                    Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                        child: ElevatedButton(
                            child: const Text("Share"),
                            onPressed: () {
                              int percentage = 0;
                              for (int i = 0; i < mb.length; i++) {
                                if (mb.getAt(i).fromInstance()[3] == true) {
                                  percentage++;
                                }
                              }
                              percentage =
                                  ((percentage / mb.length) * 100).round();
                              Share.share(
                                  'I\'ve completed $percentage% of Metroid: Samus Returns! Check out the app at github.com/jrogers15/adam_app once it\'s available!');
                            })),
                  ]), //share button

              dropdownSelection == "Other Gear"
                  ? ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][0] == itemList[index]) {
                            itemData = boxToList[i];
                          }
                        }
                        return Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1))),
                            child: CheckboxListTile(
                              title: itemData[3]
                                  ? RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                              color: Colors.blue[300],
                                              decoration:
                                                  TextDecoration.lineThrough),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough))
                                        ]))
                                  : RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                            color: Colors.lightBlue[300],
                                          ),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ))
                                        ])),
                              value: itemData[3],
                              onChanged: (value) {
                                value == true
                                    ? {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: true)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = true;
                                            }
                                          }
                                        })
                                      }
                                    : {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: false)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = false;
                                            }
                                          }
                                        })
                                      };
                              },
                            ));
                      }))
                  : ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: boxToList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        if (areaTitled !=
                                [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false
                                ] &&
                            index <= 1) {
                          areaTitled = [
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false
                          ];
                        }
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][1] == index &&
                              boxToList[i][0] == "$dropdownSelection $index") {
                            itemData = boxToList[i];
                          }
                        }
                        if (areaTitled[0] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 1) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 1) ||
                            (dropdownSelection == "Aeion Tank" && index == 1) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 1) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 1)) {
                          areaTitled[0] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[0],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index:  ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[1] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 8) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 2) ||
                            (dropdownSelection == "Aeion Tank" && index == 2) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 2) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 3)) {
                          areaTitled[1] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[1],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[2] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 17) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 3) ||
                            (dropdownSelection == "Aeion Tank" && index == 4) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 3) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 5)) {
                          areaTitled[2] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[2],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[3] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 27) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 4) ||
                            (dropdownSelection == "Aeion Tank" && index == 6) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 4) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 8)) {
                          areaTitled[3] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[3],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[4] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 38) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 5) ||
                            (dropdownSelection == "Aeion Tank" && index == 8) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 9) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 12)) {
                          areaTitled[4] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[4],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[5] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 48) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 7) ||
                            (dropdownSelection == "Aeion Tank" &&
                                index == 11) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 10) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 17)) {
                          areaTitled[5] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[5],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[6] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 58) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 8) ||
                            (dropdownSelection == "Aeion Tank" &&
                                index == 13) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 12) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 22)) {
                          areaTitled[6] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[6],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[7] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 64) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 9) ||
                            (dropdownSelection == "Aeion Tank" &&
                                index == 14) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 14) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 25)) {
                          areaTitled[7] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[7],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[8] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 71) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 10) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 15) ||
                            (dropdownSelection == "Super Missiles" &&
                                index == 27)) {
                          areaTitled[8] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[8],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (mb.get("$dropdownSelection $index") != null) {
                          return Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: CheckboxListTile(
                                title: itemData[3]
                                    ? RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                                color: Colors.blue[300],
                                                decoration:
                                                    TextDecoration.lineThrough),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough))
                                          ]))
                                    : RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                              color: Colors.lightBlue[300],
                                            ),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.white))
                                          ])),
                                value: itemData[3],
                                onChanged: (value) {
                                  value == true
                                      ? {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: true)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = true;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                          })
                                        }
                                      : {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: false)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = false;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                          })
                                        };
                                },
                              ));
                        } else {
                          return Container();
                        }
                      })),
              const SizedBox(height: 30)
            ])));
  }
}

class OtherM extends StatefulWidget {
  const OtherM({super.key});
  @override
  State<OtherM> createState() => _OtherMState();
}

class _OtherMState extends State<OtherM> {
  static final List<String> url = [
    "https://metroiddatabase.com/wp-content/uploads/Metroid-Other-M/metroidotherm_map_mainsector.jpg",
    "https://metroiddatabase.com/wp-content/uploads/Metroid-Other-M/metroidotherm_map_sector1-1800x1557.jpg",
    "https://metroiddatabase.com/wp-content/uploads/Metroid-Other-M/metroidotherm_map_sector2.jpg",
    "https://metroiddatabase.com/wp-content/uploads/Metroid-Other-M/metroidotherm_map_sector3-1800x1070.jpg",
    "https://metroiddatabase.com/wp-content/uploads/Metroid-Other-M/metroidotherm_map_bio.jpg"
  ];
  static final List<String> tag = ['7m1', '7m2', '7m3', '7m4', '7m5'];
  List<String> itemList = [
    'Missile Launcher',
    'Morph Ball Bomb',
    'Diffusion Beam',
    'Ice Beam',
    'Varia Suit',
    'Speed Booster',
    'Wave Beam',
    'Grapple Beam',
    'Super Missile',
    'Plasma Beam',
    'Space Jump/Screw Attack',
    'Seeker Missile',
    'Gravity Suit',
    'Power Bomb'
  ];
  List<String> areaList = [
    'Main Sector',
    'Sector 1',
    'Sector 2',
    'Sector 3',
    'Bioweapon Research Center'
  ];
  List<bool> areaTitled = [false, false, false, false, false];
  List<dynamic> boxToList = [];
  var mb = Hive.box('OtherM');
  String dropdownSelection = "Missile Tank";
  @override
  Widget build(BuildContext context) {
    if (!Hive.box('OtherM').isOpen) {
      retrieveBox('OtherM');
    }
    setState(() {
      for (int i = 0; i < mb.length; i++) {
        boxToList.add(mb.getAt(i).fromInstance());
      }
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Metroid: Other M"),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height / 3,
                  alignment: Alignment.center,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      mapImageBuilder(url[0], tag[0], context),
                      mapImageBuilder(url[1], tag[1], context),
                      mapImageBuilder(url[2], tag[2], context),
                      mapImageBuilder(url[3], tag[3], context),
                      mapImageBuilder(url[4], tag[4], context)
                    ],
                  )),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
                        child: ElevatedButton(
                            onPressed: () {
                              listResetButton('OtherM');
                              boxToList.clear();
                              setState(() {
                                for (int i = 0; i < mb.length; i++) {
                                  boxToList.add(mb.getAt(i).fromInstance());
                                  areaTitled = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false
                                  ];
                                }
                              });
                            },
                            child: const Text("Reset"))),
                    DropdownButton(
                        underline: const DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 1.0))),
                        ),
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.grey[600],
                        hint: Text(dropdownSelection,
                            style: const TextStyle(color: Colors.white)),
                        items: const [
                          DropdownMenuItem(
                              value: "Missile Tank",
                              child: Text("Missile Tanks",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Energy Tank",
                              child: Text("Energy Tanks",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Energy Part",
                              child: Text("Energy Part",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "E-Recovery Tank",
                              child: Text("E-Recovery Tanks",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Accel Charge",
                              child: Text("Accel Charges",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Other Gear",
                              child: Text("Other Gear",
                                  style: TextStyle(color: Colors.white))),
                        ],
                        onChanged: (String? value) => setState(() {
                              dropdownSelection = value!;
                            })),
                    Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                        child: ElevatedButton(
                            child: const Text("Share"),
                            onPressed: () {
                              int percentage = 0;
                              for (int i = 0; i < mb.length; i++) {
                                if (mb.getAt(i).fromInstance()[3] == true) {
                                  percentage++;
                                }
                              }
                              percentage =
                                  ((percentage / mb.length) * 100).round();
                              Share.share(
                                  'I\'ve completed $percentage% of Metroid: Other M! Check out the app at github.com/jrogers15/adam_app once it\'s available!');
                            })),
                  ]), //share button

              dropdownSelection == "Other Gear"
                  ? ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][0] == itemList[index]) {
                            itemData = boxToList[i];
                          }
                        }
                        return Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1))),
                            child: CheckboxListTile(
                              title: itemData[3]
                                  ? RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                              color: Colors.blue[300],
                                              decoration:
                                                  TextDecoration.lineThrough),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough))
                                        ]))
                                  : RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                            color: Colors.lightBlue[300],
                                          ),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ))
                                        ])),
                              value: itemData[3],
                              onChanged: (value) {
                                value == true
                                    ? {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: true)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = true;
                                            }
                                          }
                                        })
                                      }
                                    : {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: false)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = false;
                                            }
                                          }
                                        })
                                      };
                              },
                            ));
                      }))
                  : ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: boxToList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        if (areaTitled !=
                                [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                ] &&
                            index <= 1) {
                          areaTitled = [
                            false,
                            false,
                            false,
                            false,
                            false,
                          ];
                        }
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][1] == index &&
                              boxToList[i][0] == "$dropdownSelection $index") {
                            itemData = boxToList[i];
                          }
                        }
                        if (areaTitled[0] == false &&
                                (dropdownSelection == "Missile Tank" &&
                                    index == 1) ||
                            (dropdownSelection == "Energy Part" &&
                                index == 1)) {
                          areaTitled[0] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[0],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[1] == false &&
                                (dropdownSelection == "Missile Tank" &&
                                    index == 10) ||
                            (dropdownSelection == "Energy Part" &&
                                index == 3)) {
                          areaTitled[1] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[1],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[2] == false &&
                                (dropdownSelection == "Missile Tank" &&
                                    index == 36) ||
                            (dropdownSelection == "Energy Part" &&
                                index == 8)) {
                          areaTitled[2] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[2],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[3] == false &&
                                (dropdownSelection == "Missile Tank" &&
                                    index == 55) ||
                            (dropdownSelection == "Energy Part" &&
                                index == 12)) {
                          areaTitled[3] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[3],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[4] == false &&
                            (dropdownSelection == "Missile Tank" &&
                                index == 68)) {
                          areaTitled[4] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[4],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (mb.get("$dropdownSelection $index") != null) {
                          return Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: CheckboxListTile(
                                title: itemData[3]
                                    ? RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                                color: Colors.blue[300],
                                                decoration:
                                                    TextDecoration.lineThrough),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough))
                                          ]))
                                    : RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                              color: Colors.lightBlue[300],
                                            ),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.white))
                                          ])),
                                value: itemData[3],
                                onChanged: (value) {
                                  value == true
                                      ? {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: true)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = true;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                            ];
                                          })
                                        }
                                      : {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: false)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = false;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                            ];
                                          })
                                        };
                                },
                              ));
                        } else {
                          return Container();
                        }
                      })),
              const SizedBox(height: 30)
            ])));
  }
}

class Dread extends StatefulWidget {
  const Dread({super.key});
  @override
  State<Dread> createState() => _DreadState();
}

class _DreadState extends State<Dread> {
  static final List<String> url = [
    "https://www.metroid-database.com/wp-content/uploads/2022/09/DreadMap_full_by_nordub.ca_8bit.png",
    'https://www.metroid-database.com/wp-content/uploads/Metroid-Dread/Metroid_Dread_Map_Artaria.png',
    'https://www.metroid-database.com/wp-content/uploads/Metroid-Dread/Metroid_Dread_Map_Burenia.png',
    'https://www.metroid-database.com/wp-content/uploads/Metroid-Dread/Metroid_Dread_Map_Cataris.png',
    'https://www.metroid-database.com/wp-content/uploads/Metroid-Dread/Metroid_Dread_Map_Dairon.png',
    'https://www.metroid-database.com/wp-content/uploads/Metroid-Dread/Metroid_Dread_Map_Ghavoran_and_Elun.png',
    'https://www.metroid-database.com/wp-content/uploads/Metroid-Dread/Metroid_Dread_Map_Ferenia.png',
    'https://www.metroid-database.com/wp-content/uploads/Metroid-Dread/Metroid_Dread_Map_Hanubia_and_Itorash.png'
  ];
  static final List<String> tag = [
    '8m1',
    '8m2',
    '8m3',
    '8m4',
    '8m5',
    '8m6',
    '8m7',
    '8m8'
  ];
  List<dynamic> boxToList = [];
  List<String> itemList = [
    'Charge Beam',
    'Spider Magnet',
    'Phantom Cloak',
    'Wide Beam',
    'Morph Ball',
    'Varia Suit',
    'Diffusion Beam',
    'Morph Ball Bomb',
    'Flash Shift',
    'Speed Booster',
    'Grapple Beam',
    'Super Missile',
    'Plasma Beam',
    'Spin Boost',
    'Ice Missile',
    'Pulse Radar',
    'Storm Missiles',
    'Space Jump',
    'Gravity Suit',
    'Screw Attack',
    'Cross Bomb',
    'Wave Beam',
    'Power Bomb'
  ];
  List<String> areaList = [
    "Artaria",
    'Cataria',
    'Dairon',
    'Burenia',
    'Ferenia',
    'Ghavoran',
    'Elun',
    'Hanubia'
  ];
  List<bool> areaTitled = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  var mb = Hive.box('Dread');
  String dropdownSelection = "Missiles";
  @override
  Widget build(BuildContext context) {
    if (!Hive.box('Dread').isOpen) {
      retrieveBox('Dread');
    }
    setState(() {
      for (int i = 0; i < mb.length; i++) {
        boxToList.add(mb.getAt(i).fromInstance());
      }
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Metroid Dread"),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height / 3,
                  alignment: Alignment.center,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      mapImageBuilder(url[0], tag[0], context),
                      mapImageBuilder(url[1], tag[1], context),
                      mapImageBuilder(url[2], tag[2], context),
                      mapImageBuilder(url[3], tag[3], context),
                      mapImageBuilder(url[4], tag[4], context),
                      mapImageBuilder(url[5], tag[5], context),
                      mapImageBuilder(url[6], tag[6], context),
                      mapImageBuilder(url[7], tag[7], context),
                    ],
                  )),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
                        child: ElevatedButton(
                            onPressed: () {
                              listResetButton('Dread');
                              boxToList.clear();
                              setState(() {
                                for (int i = 0; i < mb.length; i++) {
                                  boxToList.add(mb.getAt(i).fromInstance());
                                  areaTitled = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false
                                  ];
                                }
                              });
                            },
                            child: const Text("Reset"))),
                    DropdownButton(
                        underline: const DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 1.0))),
                        ),
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.grey[600],
                        hint: Text(dropdownSelection,
                            style: const TextStyle(color: Colors.white)),
                        items: const [
                          DropdownMenuItem(
                              value: "Missiles",
                              child: Text("Missiles",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Energy Tank",
                              child: Text("Energy Tanks",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Energy Part",
                              child: Text("Energy Parts",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Missile+ Tank",
                              child: Text("Missile+ Tanks",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Power Bomb",
                              child: Text("Power Bombs",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Other Gear",
                              child: Text("Other Gear",
                                  style: TextStyle(color: Colors.white)))
                        ],
                        onChanged: (String? value) => setState(() {
                              dropdownSelection = value!;
                              areaTitled = [
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false
                              ];
                            })),
                    Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                        child: ElevatedButton(
                            child: const Text("Share"),
                            onPressed: () {
                              int percentage = 0;
                              for (int i = 0; i < mb.length; i++) {
                                if (mb.getAt(i).fromInstance()[3] == true) {
                                  percentage++;
                                }
                              }
                              percentage =
                                  ((percentage / mb.length) * 100).round();
                              Share.share(
                                  'I\'ve completed $percentage% of Metroid Dread! Check out the app at github.com/jrogers15/adam_app once it\'s available!');
                            })),
                  ]), //share button

              dropdownSelection == "Other Gear"
                  ? ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][0] == itemList[index]) {
                            itemData = boxToList[i];
                          }
                        }
                        return Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1))),
                            child: CheckboxListTile(
                              title: itemData[3]
                                  ? RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                              color: Colors.blue[300],
                                              decoration:
                                                  TextDecoration.lineThrough),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough))
                                        ]))
                                  : RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                            color: Colors.lightBlue[300],
                                          ),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ))
                                        ])),
                              value: itemData[3],
                              onChanged: (value) {
                                value == true
                                    ? {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: true)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = true;
                                            }
                                          }
                                        })
                                      }
                                    : {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: false)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = false;
                                            }
                                          }
                                        })
                                      };
                              },
                            ));
                      }))
                  : ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: boxToList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        if (areaTitled !=
                                [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false
                                ] &&
                            index <= 1) {
                          areaTitled = [
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false
                          ];
                        }
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][1] == index &&
                              boxToList[i][0] == "$dropdownSelection $index") {
                            itemData = boxToList[i];
                          }
                        }
                        if (areaTitled[0] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 1) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 1) ||
                            (dropdownSelection == "Energy Part" &&
                                index == 1) ||
                            (dropdownSelection == "Power Bomb" && index == 1) ||
                            (dropdownSelection == "Missile+ Tank" &&
                                index == 1)) {
                          areaTitled[0] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[0],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index:  ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[1] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 23) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 3) ||
                            (dropdownSelection == "Energy Part" &&
                                index == 3) ||
                            (dropdownSelection == "Power Bomb" && index == 4) ||
                            (dropdownSelection == "Missile+ Tank" &&
                                index == 3)) {
                          areaTitled[1] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[1],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[2] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 37) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 4) ||
                            (dropdownSelection == "Energy Part" &&
                                index == 5) ||
                            (dropdownSelection == "Power Bomb" && index == 7) ||
                            (dropdownSelection == "Missile+ Tank" &&
                                index == 4)) {
                          areaTitled[2] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[2],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[3] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 48) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 5) ||
                            (dropdownSelection == "Energy Part" &&
                                index == 9) ||
                            (dropdownSelection == "Power Bomb" && index == 8) ||
                            (dropdownSelection == "Missile+ Tank" &&
                                index == 5)) {
                          areaTitled[3] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[3],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[4] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 56) ||
                            (dropdownSelection == "Energy Part" &&
                                index == 11) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 10) ||
                            (dropdownSelection == "Missile+ Tank" &&
                                index == 9)) {
                          areaTitled[4] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[4],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[5] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 62) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 7) ||
                            (dropdownSelection == "Energy Part" &&
                                index == 15) ||
                            (dropdownSelection == "Power Bomb" &&
                                index == 11) ||
                            (dropdownSelection == "Missile+ Tank" &&
                                index == 11)) {
                          areaTitled[5] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[5],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[6] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 72) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 8) ||
                            (dropdownSelection == "Power Bomb" &&
                                index == 12)) {
                          areaTitled[6] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[6],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[7] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 74) ||
                            (dropdownSelection == "Power Bomb" &&
                                index == 13)) {
                          areaTitled[7] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[7],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (mb.get("$dropdownSelection $index") != null) {
                          return Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: CheckboxListTile(
                                title: itemData[3]
                                    ? RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                                color: Colors.blue[300],
                                                decoration:
                                                    TextDecoration.lineThrough),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough))
                                          ]))
                                    : RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                              color: Colors.lightBlue[300],
                                            ),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.white))
                                          ])),
                                value: itemData[3],
                                onChanged: (value) {
                                  value == true
                                      ? {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: true)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = true;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                          })
                                        }
                                      : {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: false)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = false;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                          })
                                        };
                                },
                              ));
                        } else {
                          return Container();
                        }
                      })),
              const SizedBox(height: 30)
            ])));
  }
}

class Prime extends StatefulWidget {
  const Prime({super.key});
  @override
  State<Prime> createState() => _PrimeState();
}

class _PrimeState extends State<Prime> {
  static final List<String> url = [
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime/metroidprime_map_frigate.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime/metroidprime_map_tallon.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime/metroidprime_map_chozo-1800x1611.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime/metroidprime_map_magmoor-1091x2400.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime/metroidprime_map_phendrana-1234x2400.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime/metroidprime_map_mines-1800x2100.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime/metroidprime_map_crater.jpg'
  ];
  static final List<String> tag = [
    'p1m1',
    'p1m2',
    'p1m3',
    'p1m4',
    'p1m5',
    'p1m6',
    'p1m7'
  ];
  List<dynamic> boxToList = [];
  List<String> itemList = [
    'Missile Launcher',
    'Morph Ball',
    'Charge Beam',
    'Morph Ball Bomb',
    'Varia Suit',
    'Boost Ball',
    'Space Jump Boots',
    'Wave Beam',
    'Super Missile',
    'Thermal Visor',
    'Spider Ball',
    'Ice Beam',
    'Gravity Suit',
    'Power Bomb',
    'Grapple Beam',
    'X-Ray Visor',
    'Wavebuster',
    'Ice Spreader',
    'Plasma Beam',
    'Flamethrower',
    'Phazon Suit',
    'Phazon Beam'
  ];
  List<String> areaList = [
    "Tallon Overworld",
    "Chozo Ruins",
    "Magmoor Caverns",
    "Phendrana Drifts",
    "Phazon Mines"
  ];
  List<bool> areaTitled = [false, false, false, false, false];
  var mb = Hive.box('Prime');
  String dropdownSelection = "Missile Expansion";
  @override
  Widget build(BuildContext context) {
    if (!Hive.box('Prime').isOpen) {
      retrieveBox('Prime');
    }
    setState(() {
      for (int i = 0; i < mb.length; i++) {
        boxToList.add(mb.getAt(i).fromInstance());
      }
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Metroid Prime"),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height / 3,
                  alignment: Alignment.center,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      mapImageBuilder(url[0], tag[0], context),
                      mapImageBuilder(url[1], tag[1], context),
                      mapImageBuilder(url[2], tag[2], context),
                      mapImageBuilder(url[3], tag[3], context),
                      mapImageBuilder(url[4], tag[4], context),
                      mapImageBuilder(url[5], tag[5], context),
                      mapImageBuilder(url[6], tag[6], context)
                    ],
                  )),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
                        child: ElevatedButton(
                            onPressed: () {
                              listResetButton('Prime');
                              boxToList.clear();
                              setState(() {
                                for (int i = 0; i < mb.length; i++) {
                                  boxToList.add(mb.getAt(i).fromInstance());
                                  areaTitled = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false
                                  ];
                                }
                              });
                            },
                            child: const Text("Reset"))),
                    DropdownButton(
                        underline: const DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 1.0))),
                        ),
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.grey[600],
                        hint: Text(dropdownSelection,
                            style: const TextStyle(color: Colors.white)),
                        items: const [
                          DropdownMenuItem(
                              value: "Missile Expansion",
                              child: Text("Missile Expansions",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Energy Tank",
                              child: Text("Energy Tanks",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Power Bombs",
                              child: Text("Power Bombs",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Chozo Artifact",
                              child: Text("Chozo Artifacts",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Other Gear",
                              child: Text("Other Gear",
                                  style: TextStyle(color: Colors.white)))
                        ],
                        onChanged: (String? value) => setState(() {
                              dropdownSelection = value!;
                              areaTitled = [false, false, false, false, false];
                            })),
                    Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                        child: ElevatedButton(
                            child: const Text("Share"),
                            onPressed: () {
                              int percentage = 0;
                              for (int i = 0; i < mb.length; i++) {
                                if (mb.getAt(i).fromInstance()[3] == true) {
                                  percentage++;
                                }
                              }
                              percentage =
                                  ((percentage / mb.length) * 100).round();
                              Share.share(
                                  'I\'ve completed $percentage% of Metroid Prime! Check out the app at github.com/jrogers15/adam_app once it\'s available!');
                            })),
                  ]), //share button

              dropdownSelection == "Other Gear"
                  ? ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][0] == itemList[index]) {
                            itemData = boxToList[i];
                          }
                        }
                        return Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1))),
                            child: CheckboxListTile(
                              title: itemData[3]
                                  ? RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                              color: Colors.blue[300],
                                              decoration:
                                                  TextDecoration.lineThrough),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough))
                                        ]))
                                  : RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                            color: Colors.lightBlue[300],
                                          ),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ))
                                        ])),
                              value: itemData[3],
                              onChanged: (value) {
                                value == true
                                    ? {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: true)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = true;
                                            }
                                          }
                                        })
                                      }
                                    : {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: false)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = false;
                                            }
                                          }
                                        })
                                      };
                              },
                            ));
                      }))
                  : ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: boxToList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        if (areaTitled !=
                                [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                ] &&
                            index <= 1) {
                          areaTitled = [
                            false,
                            false,
                            false,
                            false,
                            false,
                          ];
                        }
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][1] == index &&
                              boxToList[i][0] == "$dropdownSelection $index") {
                            itemData = boxToList[i];
                          }
                        }
                        if (areaTitled[0] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 1) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 1) ||
                            (dropdownSelection == "Chozo Artifact" &&
                                index == 1)) {
                          areaTitled[0] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[0],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index:  ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[1] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 10) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 3) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 1) ||
                            (dropdownSelection == "Chozo Artifact" &&
                                index == 3)) {
                          areaTitled[1] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[1],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[2] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 30) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 8) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 2) ||
                            (dropdownSelection == "Chozo Artifact" &&
                                index == 6)) {
                          areaTitled[2] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[2],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[3] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 33) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 10) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 3) ||
                            (dropdownSelection == "Chozo Artifact" &&
                                index == 8)) {
                          areaTitled[3] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[3],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[4] == false &&
                                (dropdownSelection == "Missiles" &&
                                    index == 42) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 13) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 5) ||
                            (dropdownSelection == "Chozo Artifact" &&
                                index == 11)) {
                          areaTitled[4] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[4],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (mb.get("$dropdownSelection $index") != null) {
                          return Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: CheckboxListTile(
                                title: itemData[3]
                                    ? RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                                color: Colors.blue[300],
                                                decoration:
                                                    TextDecoration.lineThrough),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough))
                                          ]))
                                    : RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                              color: Colors.lightBlue[300],
                                            ),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.white))
                                          ])),
                                value: itemData[3],
                                onChanged: (value) {
                                  value == true
                                      ? {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: true)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = true;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                            ];
                                          })
                                        }
                                      : {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: false)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = false;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false,
                                            ];
                                          })
                                        };
                                },
                              ));
                        } else {
                          return Container();
                        }
                      })),
              const SizedBox(height: 30)
            ])));
  }
}

class Prime2 extends StatefulWidget {
  const Prime2({super.key});
  @override
  State<Prime2> createState() => _Prime2State();
}

class _Prime2State extends State<Prime2> {
  static final List<String> url = [
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime-2/metroidprime2_map_light_temple.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime-2/metroidprime2_map_light_agon-1800x1267.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime-2/metroidprime2_map_light_torvus-1714x2400.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime-2/metroidprime2_map_light_sanctuary-1800x1045.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime-2/metroidprime2_map_light_dark_great_sky.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime-2/metroidprime2_map_dark_agon-1800x1267.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime-2/metroidprime2_map_dark_temple.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime-2/metroidprime2_map_dark_torvus-1714x2400.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime-2/metroidprime2_map_dark_hive-1800x990.jpg'
  ];
  static final List<String> tag = [
    'p2m1',
    'p2m2',
    'p2m3',
    'p2m4',
    'p2m5',
    'p2m6',
    'p2m7',
    'p2m8',
    'p2m9'
  ];
  List<dynamic> boxToList = [];
  List<String> itemList = [
    'Missile Launcher',
    'Morph Ball Bomb',
    'Space Jump Boots',
    'Dark Beam',
    'Light Beam',
    'Dark Suit',
    'Super Missile',
    'Boost Ball',
    'Seeker Launcher',
    'Gravity Boost',
    'Grapple Beam',
    'Dark Visor',
    'Spider Ball',
    'Power Bomb',
    'Darkburst',
    'Sunburst',
    'Echo Visor',
    'Screw Attack',
    'Annihilator Beam',
    'Light Suit',
    'Sonic Boom'
  ];
  List<String> areaList = [
    'Temple Grounds',
    'Great Temple',
    'Agon Wastes',
    'Torvus Bog',
    'Sanctuary Fortress',
    'Ing Hive'
  ];
  List<bool> areaTitled = [false, false, false, false, false, false];
  var mb = Hive.box('Prime2');
  String dropdownSelection = "Missile Expansion";
  @override
  Widget build(BuildContext context) {
    if (!Hive.box('Prime2').isOpen) {
      retrieveBox('Prime2');
    }
    setState(() {
      for (int i = 0; i < mb.length; i++) {
        boxToList.add(mb.getAt(i).fromInstance());
      }
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Metroid Prime 2: Echoes"),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height / 3,
                  alignment: Alignment.center,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      mapImageBuilder(url[0], tag[0], context),
                      mapImageBuilder(url[1], tag[1], context),
                      mapImageBuilder(url[2], tag[2], context),
                      mapImageBuilder(url[3], tag[3], context),
                      mapImageBuilder(url[4], tag[4], context),
                      mapImageBuilder(url[5], tag[5], context),
                      mapImageBuilder(url[6], tag[6], context),
                      mapImageBuilder(url[7], tag[7], context),
                      mapImageBuilder(url[8], tag[8], context)
                    ],
                  )),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
                        child: ElevatedButton(
                            onPressed: () {
                              listResetButton('Prime2');
                              boxToList.clear();
                              setState(() {
                                for (int i = 0; i < mb.length; i++) {
                                  boxToList.add(mb.getAt(i).fromInstance());
                                  areaTitled = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false
                                  ];
                                }
                              });
                            },
                            child: const Text("Reset"))),
                    DropdownButton(
                        underline: const DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 1.0))),
                        ),
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.grey[600],
                        hint: Text(dropdownSelection,
                            style: const TextStyle(color: Colors.white)),
                        items: const [
                          DropdownMenuItem(
                              value: "Missile Expansion",
                              child: Text("Missile Expansions",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Energy Tank",
                              child: Text("Energy Tanks",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Sky Temple Key",
                              child: Text("Sky Temple Key",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Dark Temple Key",
                              child: Text("Dark Temple Keys",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Power Bombs",
                              child: Text("Power Bombs",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Beam Ammo Expansion",
                              child: Text("Beam Ammo Expansions",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Other Gear",
                              child: Text("Other Gear",
                                  style: TextStyle(color: Colors.white)))
                        ],
                        onChanged: (String? value) => setState(() {
                              dropdownSelection = value!;
                              areaTitled = [
                                false,
                                false,
                                false,
                                false,
                                false,
                                false
                              ];
                            })),
                    Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                        child: ElevatedButton(
                            child: const Text("Share"),
                            onPressed: () {
                              int percentage = 0;
                              for (int i = 0; i < mb.length; i++) {
                                if (mb.getAt(i).fromInstance()[3] == true) {
                                  percentage++;
                                }
                              }
                              percentage =
                                  ((percentage / mb.length) * 100).round();
                              Share.share(
                                  'I\'ve completed $percentage% of Metroid Prime 2: Echoes! Check out the app at github.com/jrogers15/adam_app once it\'s available!');
                            })),
                  ]), //share button

              dropdownSelection == "Other Gear"
                  ? ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][0] == itemList[index]) {
                            itemData = boxToList[i];
                          }
                        }
                        return Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1))),
                            child: CheckboxListTile(
                              title: itemData[3]
                                  ? RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                              color: Colors.blue[300],
                                              decoration:
                                                  TextDecoration.lineThrough),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough))
                                        ]))
                                  : RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                            color: Colors.lightBlue[300],
                                          ),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ))
                                        ])),
                              value: itemData[3],
                              onChanged: (value) {
                                value == true
                                    ? {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: true)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = true;
                                            }
                                          }
                                        })
                                      }
                                    : {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: false)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = false;
                                            }
                                          }
                                        })
                                      };
                              },
                            ));
                      }))
                  : ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: boxToList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        if (areaTitled !=
                                [false, false, false, false, false, false] &&
                            index <= 1) {
                          areaTitled = [
                            false,
                            false,
                            false,
                            false,
                            false,
                            false
                          ];
                        }
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][1] == index &&
                              boxToList[i][0] == "$dropdownSelection $index") {
                            itemData = boxToList[i];
                          }
                        }
                        if (areaTitled[0] == false &&
                                (dropdownSelection == "Missile Expansion" &&
                                    index == 1) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 1) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 1) ||
                            (dropdownSelection == "Beam Ammo Expansion" &&
                                index == 1) ||
                            (dropdownSelection == "Sky Temple Key" &&
                                index == 7)) {
                          areaTitled[0] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[0],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index:  ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[1] == false &&
                            (dropdownSelection == "Missile Expansion" &&
                                index == 10)) {
                          areaTitled[1] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[1],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[2] == false &&
                                (dropdownSelection == "Missile Expansion" &&
                                    index == 12) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 4) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 2) ||
                            (dropdownSelection == "Beam Ammo Expansion" &&
                                index == 2) ||
                            (dropdownSelection == "Dark Temple Key" &&
                                index == 1) ||
                            (dropdownSelection == "Sky Temple Key" &&
                                index == 1)) {
                          areaTitled[2] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[2],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[3] == false &&
                                (dropdownSelection == "Missile Expansion" &&
                                    index == 27) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 8) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 4) ||
                            (dropdownSelection == "Beam Ammo Expansion" &&
                                index == 3) ||
                            (dropdownSelection == "Dark Temple Key" &&
                                index == 4) ||
                            (dropdownSelection == "Sky Temple Key" &&
                                index == 3)) {
                          areaTitled[3] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[3],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[4] == false &&
                                (dropdownSelection == "Missile Expansion" &&
                                    index == 41) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 13) ||
                            (dropdownSelection == "Power Bombs" &&
                                index == 6) ||
                            (dropdownSelection == "Beam Ammo Expansion" &&
                                index == 4)) {
                          areaTitled[4] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[4],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[5] == false &&
                                (dropdownSelection == "Missile Expansion" &&
                                    index == 48) ||
                            (dropdownSelection == "Dark Temple Key" &&
                                index == 7) ||
                            (dropdownSelection == "Sky Temple Key" &&
                                index == 5)) {
                          areaTitled[5] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[5],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (mb.get("$dropdownSelection $index") != null) {
                          return Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: CheckboxListTile(
                                title: itemData[3]
                                    ? RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                                color: Colors.blue[300],
                                                decoration:
                                                    TextDecoration.lineThrough),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough))
                                          ]))
                                    : RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                              color: Colors.lightBlue[300],
                                            ),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.white))
                                          ])),
                                value: itemData[3],
                                onChanged: (value) {
                                  value == true
                                      ? {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: true)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = true;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                          })
                                        }
                                      : {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: false)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = false;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                          })
                                        };
                                },
                              ));
                        } else {
                          return Container();
                        }
                      })),
              const SizedBox(height: 30)
            ])));
  }
}

class Prime3 extends StatefulWidget {
  const Prime3({super.key});
  @override
  State<Prime3> createState() => _Prime3State();
}

class _Prime3State extends State<Prime3> {
  static final List<String> url = [
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime-3/metroidprime3_map_norion-1800x1942.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime-3/metroidprime3_map_olympus.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime-3/metroidprime3_map_bryyo-1783x2400.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime-3/metroidprime3_map_skytown-1800x1586.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime-3/metroidprime3_map_valhalla.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime-3/metroidprime3_map_piratehomeworld-1800x1976.jpg',
    'https://metroiddatabase.com/wp-content/uploads/Metroid-Prime-3/metroidprime3_map_phaaze.jpg'
  ];
  static final List<String> tag = [
    'p3m1',
    'p3m2',
    'p3m3',
    'p3m4',
    'p3m5',
    'p3m6',
    'p3m7'
  ];
  List<dynamic> boxToList = [];
  List<String> itemList = [
    'Missile Launcher',
    'Grapple Lasso',
    'Phazon Enhancement Device (PED) Suit',
    'Grapple Swing',
    'Ice Missile',
    'Ship Missile',
    'Hyper Ball',
    'Boost Ball',
    'Plasma Beam',
    'Screw Attack',
    'Ship Grapple',
    'Seeker Missile',
    'Hyper Missile',
    'X-Ray Visor',
    'Grapple Voltage',
    'Spider Ball',
    'Hazard Shield',
    'Nova Beam',
    'Hyper Grapple'
  ];
  List<String> areaList = [
    'Norion',
    'Bryyo',
    'Skytown',
    'Pirate Homeworld',
    'GFS Valhalla'
  ];
  List<bool> areaTitled = [false, false, false, false, false];
  var mb = Hive.box('Prime3');
  String dropdownSelection = "Missile Expansion";
  @override
  Widget build(BuildContext context) {
    if (!Hive.box('Prime3').isOpen) {
      retrieveBox('Prime3');
    }
    setState(() {
      for (int i = 0; i < mb.length; i++) {
        boxToList.add(mb.getAt(i).fromInstance());
      }
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Metroid Prime 3: Corruption"),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height / 3,
                  alignment: Alignment.center,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      mapImageBuilder(url[0], tag[0], context),
                      mapImageBuilder(url[1], tag[1], context),
                      mapImageBuilder(url[2], tag[2], context),
                      mapImageBuilder(url[3], tag[3], context),
                      mapImageBuilder(url[4], tag[4], context),
                      mapImageBuilder(url[5], tag[5], context),
                      mapImageBuilder(url[6], tag[6], context),
                    ],
                  )),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
                        child: ElevatedButton(
                            onPressed: () {
                              listResetButton('Prime3');
                              boxToList.clear();
                              setState(() {
                                for (int i = 0; i < mb.length; i++) {
                                  boxToList.add(mb.getAt(i).fromInstance());
                                  areaTitled = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false
                                  ];
                                }
                              });
                            },
                            child: const Text("Reset"))),
                    DropdownButton(
                        underline: const DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white, width: 1.0))),
                        ),
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.grey[600],
                        hint: Text(dropdownSelection,
                            style: const TextStyle(color: Colors.white)),
                        items: const [
                          DropdownMenuItem(
                              value: "Missile Expansion",
                              child: Text("Missile Expansions",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Energy Tank",
                              child: Text("Energy Tanks",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Ship Missiles",
                              child: Text("Ship Missiles",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Energy Cell",
                              child: Text("Energy Cells",
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: "Other Gear",
                              child: Text("Other Gear",
                                  style: TextStyle(color: Colors.white)))
                        ],
                        onChanged: (String? value) => setState(() {
                              dropdownSelection = value!;
                              areaTitled = [false, false, false, false, false];
                            })),
                    Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                        child: ElevatedButton(
                            child: const Text("Share"),
                            onPressed: () {
                              int percentage = 0;
                              for (int i = 0; i < mb.length; i++) {
                                if (mb.getAt(i).fromInstance()[3] == true) {
                                  percentage++;
                                }
                              }
                              percentage =
                                  ((percentage / mb.length) * 100).round();
                              Share.share(
                                  'I\'ve completed $percentage% of Metroid Prime 3: Corruption! Check out the app at github.com/jrogers15/adam_app once it\'s available!');
                            })),
                  ]), //share button

              dropdownSelection == "Other Gear"
                  ? ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][0] == itemList[index]) {
                            itemData = boxToList[i];
                          }
                        }
                        return Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1))),
                            child: CheckboxListTile(
                              title: itemData[3]
                                  ? RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                              color: Colors.blue[300],
                                              decoration:
                                                  TextDecoration.lineThrough),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough))
                                        ]))
                                  : RichText(
                                      text: TextSpan(
                                          text: "${itemList[index]}: ",
                                          style: TextStyle(
                                            color: Colors.lightBlue[300],
                                          ),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text: itemData[2],
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ))
                                        ])),
                              value: itemData[3],
                              onChanged: (value) {
                                value == true
                                    ? {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: true)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = true;
                                            }
                                          }
                                        })
                                      }
                                    : {
                                        mb.put(
                                            itemList[index],
                                            Item(
                                                itemType: itemData[0],
                                                itemId: itemData[1],
                                                location: itemData[2],
                                                checked: false)),
                                        setState(() {
                                          for (int i = 0;
                                              i < boxToList.length;
                                              i++) {
                                            if (boxToList[i][0] ==
                                                itemList[index]) {
                                              boxToList[i][3] = false;
                                            }
                                          }
                                        })
                                      };
                              },
                            ));
                      }))
                  : ListView.builder(
                      controller: ScrollController(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: boxToList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        if (areaTitled != [false, false, false, false, false] &&
                            index <= 1) {
                          areaTitled = [false, false, false, false, false];
                        }
                        List<dynamic> itemData = [];
                        for (int i = 0; i < boxToList.length; i++) {
                          if (boxToList[i][1] == index &&
                              boxToList[i][0] == "$dropdownSelection $index") {
                            itemData = boxToList[i];
                          }
                        }
                        if (areaTitled[0] == false &&
                                (dropdownSelection == "Missile Expansion" &&
                                    index == 1) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 2)) {
                          areaTitled[0] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[0],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index:  ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[1] == false &&
                                (dropdownSelection == "Missile Expansion" &&
                                    index == 6) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 3) ||
                            (dropdownSelection == "Ship Missile" &&
                                index == 1)) {
                          areaTitled[1] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[1],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[2] == false &&
                                (dropdownSelection == "Missile Expansion" &&
                                    index == 26) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 8) ||
                            (dropdownSelection == "Ship Missile" &&
                                index == 4)) {
                          areaTitled[2] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[2],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[3] == false &&
                                (dropdownSelection == "Missile Expansion" &&
                                    index == 37) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 12) ||
                            (dropdownSelection == "Ship Missile" &&
                                index == 6)) {
                          areaTitled[3] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[3],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (areaTitled[4] == false &&
                                (dropdownSelection == "Missile Expansion" &&
                                    index == 48) ||
                            (dropdownSelection == "Energy Tank" &&
                                index == 14) ||
                            (dropdownSelection == "Ship Missile" &&
                                index == 8)) {
                          areaTitled[4] = true;
                          return Column(children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 15),
                                child: Text(areaList[4],
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 28))),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1))),
                                child: CheckboxListTile(
                                  title: itemData[3]
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                  color: Colors.blue[300],
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ]))
                                      : RichText(
                                          text: TextSpan(
                                              text:
                                                  "$dropdownSelection $index: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[300],
                                              ),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text: itemData[2],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ])),
                                  value: itemData[3],
                                  onChanged: (value) {
                                    value == true
                                        ? {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: true)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = true;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          }
                                        : {
                                            mb.put(
                                                "$dropdownSelection $index",
                                                Item(
                                                    itemType: itemData[0],
                                                    itemId: itemData[1],
                                                    location: itemData[2],
                                                    checked: false)),
                                            setState(() {
                                              for (int i = 0;
                                                  i < boxToList.length;
                                                  i++) {
                                                if (boxToList[i][1] == index &&
                                                    boxToList[i][0] ==
                                                        "$dropdownSelection $index") {
                                                  boxToList[i][3] = false;
                                                }
                                              }
                                              areaTitled = [
                                                false,
                                                false,
                                                false,
                                                false,
                                                false
                                              ];
                                            })
                                          };
                                  },
                                ))
                          ]);
                        }
                        if (mb.get("$dropdownSelection $index") != null) {
                          return Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: CheckboxListTile(
                                title: itemData[3]
                                    ? RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                                color: Colors.blue[300],
                                                decoration:
                                                    TextDecoration.lineThrough),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough))
                                          ]))
                                    : RichText(
                                        text: TextSpan(
                                            text: "$dropdownSelection $index: ",
                                            style: TextStyle(
                                              color: Colors.lightBlue[300],
                                            ),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text: itemData[2],
                                                style: const TextStyle(
                                                    color: Colors.white))
                                          ])),
                                value: itemData[3],
                                onChanged: (value) {
                                  value == true
                                      ? {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: true)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = true;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                          })
                                        }
                                      : {
                                          mb.put(
                                              "$dropdownSelection $index",
                                              Item(
                                                  itemType: itemData[0],
                                                  itemId: itemData[1],
                                                  location: itemData[2],
                                                  checked: false)),
                                          setState(() {
                                            for (int i = 0;
                                                i < boxToList.length;
                                                i++) {
                                              if (boxToList[i][1] == index &&
                                                  boxToList[i][0] ==
                                                      "$dropdownSelection $index") {
                                                boxToList[i][3] = false;
                                              }
                                            }
                                            areaTitled = [
                                              false,
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                          })
                                        };
                                },
                              ));
                        } else {
                          return Container();
                        }
                      })),
              const SizedBox(height: 30)
            ])));
  }
}
