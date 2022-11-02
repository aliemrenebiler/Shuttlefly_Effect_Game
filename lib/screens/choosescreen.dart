import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../database/classes.dart';
import '../database/methods.dart';
import '../database/variables.dart';
import '../database/theme.dart';

class ChooseScreen extends StatelessWidget {
  const ChooseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SEColors().dblue,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              child: const TopBar(),
            ),
            Expanded(
              child: Row(
                children: [
                  for (int i = 0; i < 3; i++)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: CharBox(index: i),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TOP BAR
class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: SEColors().lblue,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: seBorderWidth,
          color: SEColors().blue,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                currentEvent = await getRandomEvent();
                await SharedPrefsService().saveEventID();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, '/gamescreen');
              }
            },
          ),
        ],
      ),
    );
  }
}

class TopBarButton extends StatelessWidget {
  final String text;
  final VoidCallback onTapAction;
  const TopBarButton({
    super.key,
    required this.text,
    required this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapAction,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(15),
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: SEColors().white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

// SELECTION BOXES
class CharBox extends StatelessWidget {
  final int index;
  const CharBox({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: SEColors().lgrey,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
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
              'CHARACTER #${index + 1}',
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
            child: CharSelectionBox(index: index),
          ),
          Expanded(
            flex: 2,
            child: SkillSelectionBox(index: index),
          ),
        ],
      ),
    );
  }
}

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
                        : 'The\n${selectedSkills[widget.index]!.name}',
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

// ALERT BOX
class PopUpAlertBox extends StatelessWidget {
  final String alertTitle;
  final String? alertDesc;
  final bool closeButtonActive;
  final List<Widget>? buttons;
  const PopUpAlertBox({
    super.key,
    required this.alertTitle,
    this.alertDesc,
    required this.closeButtonActive,
    this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Container(
        width: 300,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: SEColors().white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: seBorderWidth,
            color: SEColors().grey,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: closeButtonActive
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    alignment: closeButtonActive
                        ? Alignment.bottomLeft
                        : Alignment.bottomCenter,
                    child: Text(
                      alertTitle,
                      textAlign:
                          closeButtonActive ? TextAlign.left : TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                if (closeButtonActive)
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: AnyButton(
                      text: 'X',
                      onTapAction: () {
                        Navigator.pop(context);
                      },
                      height: 50,
                      width: 50,
                      textColor: SEColors().red,
                      buttonColor: SEColors().lgrey,
                      borderColor: SEColors().grey,
                    ),
                  ),
              ],
            ),
            if (alertDesc != null)
              Container(
                alignment:
                    closeButtonActive ? Alignment.centerLeft : Alignment.center,
                padding: const EdgeInsets.all(5),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    alertDesc!,
                    textAlign:
                        closeButtonActive ? TextAlign.left : TextAlign.center,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            if (buttons != null)
              for (int i = 0; i < buttons!.length; i++)
                Container(
                  padding: const EdgeInsets.all(3),
                  child: buttons![i],
                ),
          ],
        ),
      ),
    );
  }
}

// BUTTONS
class AnyButton extends StatelessWidget {
  final String text;
  final VoidCallback onTapAction;
  final double? width;
  final double? height;
  final Color textColor;
  final Color buttonColor;
  final Color borderColor;
  const AnyButton({
    super.key,
    required this.text,
    required this.onTapAction,
    this.width,
    this.height,
    required this.textColor,
    required this.buttonColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapAction,
      child: Container(
        alignment: Alignment.center,
        height: (height != null) ? height : null,
        width: (width != null) ? width : null,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: seBorderWidth,
            color: borderColor,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: textColor,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
