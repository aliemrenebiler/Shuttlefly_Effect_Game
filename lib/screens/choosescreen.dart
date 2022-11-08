import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../database/classes.dart';
import '../database/methods.dart';
import '../database/theme.dart';
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
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: SEColors().lgrey,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                width: seBorderWidth,
                                color: SEColors().grey,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'CHARACTER #${i + 1}',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: SEColors().dgrey2,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: CharSelectionBox(index: i),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: SkillSelectionBox(index: i),
                                ),
                              ],
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
              await SharedPrefsService().saveCharacters();
              currentEvent = await getRandomEvent(currentGalaxy.id);
              await SharedPrefsService().saveEventID();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, '/gamescreen');
            }
          },
        ),
      ],
    );
  }
}

// SELECTION BOXES
class CharSelectionBox extends StatefulWidget {
  final int index;

  const CharSelectionBox({
    super.key,
    required this.index,
  });
  @override
  State<CharSelectionBox> createState() => _CharSelectionBoxState();
}

class _CharSelectionBoxState extends State<CharSelectionBox> {
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
                textColor: SEColors().dgrey2,
                buttonColor: SEColors().dgrey,
                borderColor: SEColors().grey,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(3),
                padding: const EdgeInsets.all(3),
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
                    Expanded(
                      flex: 3,
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
                    Expanded(
                      flex: 1,
                      child: Container(
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
                textColor: SEColors().dgrey2,
                buttonColor: SEColors().dgrey,
                borderColor: SEColors().grey,
              ),
            ),
          ],
        );
      },
    );
  }
}

class SkillSelectionBox extends StatefulWidget {
  final int index;
  const SkillSelectionBox({
    super.key,
    required this.index,
  });
  @override
  State<SkillSelectionBox> createState() => _SkillSelectionBoxState();
}

class _SkillSelectionBoxState extends State<SkillSelectionBox> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
    counter = widget.index % totalSkillAmount;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Skill>(
      future: SQLiteServices().getSkill(counter.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          selectedSkills[widget.index] = snapshot.data!;
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
                    counter = totalSkillAmount - 1;
                  } else {
                    counter--;
                  }
                  setState(() {});
                },
                width: 35,
                textColor: SEColors().dgrey2,
                buttonColor: SEColors().dgrey,
                borderColor: SEColors().grey,
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
                        alertTitle: selectedSkills[widget.index]!.name,
                        alertDesc: selectedSkills[widget.index]!.desc,
                        closeButtonActive: true,
                      );
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(3),
                  padding: const EdgeInsets.all(3),
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
                        : selectedSkills[widget.index]!.name,
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
                  if (counter == totalSkillAmount - 1) {
                    counter = 0;
                  } else {
                    counter++;
                  }
                  setState(() {});
                },
                width: 35,
                textColor: SEColors().dgrey2,
                buttonColor: SEColors().dgrey,
                borderColor: SEColors().grey,
              ),
            ),
          ],
        );
      },
    );
  }
}
