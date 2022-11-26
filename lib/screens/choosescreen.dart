import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../backend/classes.dart';
import '../backend/methods.dart';
import '../backend/theme.dart';
import 'allglobalwidgets.dart';

class ChooseScreen extends StatelessWidget {
  const ChooseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/storyscreen');
        return true;
      },
      child: Scaffold(
        body: ContainerWithBG(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: const ChooseScreenTopBar(),
                ),
                Expanded(
                  child: Row(
                    children: [
                      for (int i = 0; i < 3; i++)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: SelectionBox(index: i),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// TOP BAR
class ChooseScreenTopBar extends StatelessWidget {
  const ChooseScreenTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TopBar(
      widgets: [
        TopBarButton(
          text: "BACK",
          onTapAction: () {
            Navigator.pushReplacementNamed(context, '/storyscreen');
          },
        ),
        Expanded(
          child: Text(
            'CHOOSE CHARACTERS',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: SEColors().white,
              fontSize: 25,
            ),
          ),
        ),
        TopBarButton(
          text: "DONE",
          onTapAction: () async {
            bool noNullChar = true;
            for (int i = 0; i < 3; i++) {
              if (selectedChars[i] == null) {
                noNullChar = false;
              }
            }
            if (noNullChar) {
              currentEvent = await getRandomEvent(currentGalaxy.id);
              await SharedPrefsService().saveGalaxyID();
              await SharedPrefsService().saveEventID();
              await SharedPrefsService().saveCharsAndProfs();
              await SharedPrefsService().saveStates();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, '/gamescreen');
            }
          },
        ),
      ],
    );
  }
}

// SELECTION BOX
class SelectionBox extends StatelessWidget {
  final int index;
  const SelectionBox({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: SEColors().black,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: seBorderWidth,
          color: SEColors().lblack,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(3),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Character ",
                      style: TextStyle(
                        color: SEColors().white,
                        fontSize: 25,
                      ),
                    ),
                    TextSpan(
                      text: "#${index + 1}",
                      style: TextStyle(
                        color: SEColors().lyellow2,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CharSelection(index: index),
          ProfSelection(index: index),
        ],
      ),
    );
  }
}

class CharSelection extends StatefulWidget {
  final int index;

  const CharSelection({
    super.key,
    required this.index,
  });
  @override
  State<CharSelection> createState() => _CharSelectionState();
}

class _CharSelectionState extends State<CharSelection> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
    counter = widget.index % totalCharAmount;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Character>(
      future: SQLiteServices().getChar(counter.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          selectedChars[widget.index] = snapshot.data!;
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              child: AnyButton(
                text: '<',
                onTapAction: () {
                  if (counter == 0) {
                    counter = totalCharAmount - 1;
                  } else {
                    counter--;
                  }
                  setState(() {});
                },
                width: 35,
                height: 140,
                textColor: SEColors().dgrey,
                buttonColor: SEColors().lblack,
                borderColor: SEColors().dgrey2,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(3),
                padding: const EdgeInsets.all(3),
                height: 140,
                decoration: BoxDecoration(
                  color: SEColors().red,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    width: seBorderWidth,
                    color: SEColors().lred,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: SEColors().red,
                              border: Border.all(
                                width: seBorderWidth,
                                color: SEColors().dred,
                              ),
                              image: (!snapshot.hasData)
                                  ? null
                                  : DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        join(
                                            "assets",
                                            "images",
                                            selectedChars[widget.index]!
                                                .imgName),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(3),
                      alignment: Alignment.center,
                      child: Text(
                        (!snapshot.hasData)
                            ? "..."
                            : selectedChars[widget.index]!.name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: SEColors().white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(3),
              child: AnyButton(
                text: '>',
                onTapAction: () {
                  if (counter == totalCharAmount - 1) {
                    counter = 0;
                  } else {
                    counter++;
                  }
                  setState(() {});
                },
                width: 35,
                height: 140,
                textColor: SEColors().dgrey,
                buttonColor: SEColors().lblack,
                borderColor: SEColors().dgrey2,
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProfSelection extends StatefulWidget {
  final int index;
  const ProfSelection({
    super.key,
    required this.index,
  });
  @override
  State<ProfSelection> createState() => _ProfSelectionState();
}

class _ProfSelectionState extends State<ProfSelection> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
    counter = widget.index % totalProfAmount;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profession>(
      future: SQLiteServices().getProf(counter.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          selectedProfs[widget.index] = snapshot.data!;
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              child: AnyButton(
                text: '<',
                onTapAction: () {
                  if (counter == 0) {
                    counter = totalProfAmount - 1;
                  } else {
                    counter--;
                  }
                  setState(() {});
                },
                width: 35,
                height: 60,
                textColor: SEColors().dgrey,
                buttonColor: SEColors().lblack,
                borderColor: SEColors().dgrey2,
              ),
            ),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PopUpAlertBox(
                        alertTitle: selectedProfs[widget.index]!.name,
                        alertDesc: selectedProfs[widget.index]!.desc,
                        closeButtonActive: true,
                      );
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(3),
                  padding: const EdgeInsets.all(3),
                  height: 60,
                  decoration: BoxDecoration(
                    color: SEColors().blue,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      width: seBorderWidth,
                      color: SEColors().lblue,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (!snapshot.hasData)
                        ? "Loading..."
                        : selectedProfs[widget.index]!.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: SEColors().white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(3),
              child: AnyButton(
                text: '>',
                onTapAction: () {
                  if (counter == totalProfAmount - 1) {
                    counter = 0;
                  } else {
                    counter++;
                  }
                  setState(() {});
                },
                width: 35,
                height: 60,
                textColor: SEColors().dgrey,
                buttonColor: SEColors().lblack,
                borderColor: SEColors().dgrey2,
              ),
            ),
          ],
        );
      },
    );
  }
}
