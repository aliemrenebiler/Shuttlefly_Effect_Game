import 'package:flutter/material.dart';

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
            padding: EdgeInsets.all(MediaQuery.of(context).size.height / 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height / 60),
                  child: const ChooseScreenTopBar(),
                ),
                Expanded(
                  child: Row(
                    children: [
                      for (int i = 0; i < 3; i++)
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height / 60),
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
              fontSize: MediaQuery.of(context).size.height / 15,
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
class SelectionBox extends StatefulWidget {
  final int index;
  const SelectionBox({
    super.key,
    required this.index,
  });

  @override
  State<SelectionBox> createState() => _SelectionBoxState();
}

class _SelectionBoxState extends State<SelectionBox> {
  int charCounter = 0;
  int profCounter = 0;

  @override
  void initState() {
    super.initState();
    charCounter = widget.index % totalCharAmount;
    profCounter = widget.index % totalProfAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 60),
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
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(MediaQuery.of(context).size.height / 120),
              child: RichText(
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: "Character ",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 20,
                        color: SEColors().white,
                      ),
                    ),
                    TextSpan(
                      text: "#${widget.index + 1}",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 20,
                        color: SEColors().lyellow2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height / 120),
                    child: AnyButton(
                      text: '<',
                      onTapAction: () {
                        if (charCounter == 0) {
                          charCounter = totalCharAmount - 1;
                        } else {
                          charCounter--;
                        }
                        setState(() {});
                      },
                      textColor: SEColors().dgrey,
                      buttonColor: SEColors().lblack,
                      borderColor: SEColors().dgrey2,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height / 120),
                    child: FutureBuilder<Character>(
                      future: SQLiteServices().getChar(charCounter.toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          selectedChars[widget.index] = snapshot.data!;
                          return CharSelection(
                            index: widget.index,
                            isEmpty: false,
                          );
                        } else {
                          return CharSelection(
                            index: widget.index,
                            isEmpty: true,
                          );
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height / 120),
                    child: AnyButton(
                      text: '>',
                      onTapAction: () {
                        if (charCounter == totalCharAmount - 1) {
                          charCounter = 0;
                        } else {
                          charCounter++;
                        }
                        setState(() {});
                      },
                      textColor: SEColors().dgrey,
                      buttonColor: SEColors().lblack,
                      borderColor: SEColors().dgrey2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height / 120),
                    child: AnyButton(
                      text: '<',
                      onTapAction: () {
                        if (profCounter == 0) {
                          profCounter = totalProfAmount - 1;
                        } else {
                          profCounter--;
                        }
                        setState(() {});
                      },
                      textColor: SEColors().dgrey,
                      buttonColor: SEColors().lblack,
                      borderColor: SEColors().dgrey2,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height / 120),
                    child: FutureBuilder<Profession>(
                      future: SQLiteServices().getProf(profCounter.toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          selectedProfs[widget.index] = snapshot.data!;
                          return ProfSelection(
                            index: widget.index,
                            isEmpty: false,
                          );
                        } else {
                          return ProfSelection(
                            index: widget.index,
                            isEmpty: true,
                          );
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height / 120),
                    child: AnyButton(
                      text: '>',
                      onTapAction: () {
                        if (profCounter == totalProfAmount - 1) {
                          profCounter = 0;
                        } else {
                          profCounter++;
                        }
                        setState(() {});
                      },
                      textColor: SEColors().dgrey,
                      buttonColor: SEColors().lblack,
                      borderColor: SEColors().dgrey2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
