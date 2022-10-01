import 'package:flutter/material.dart';

import '../database/classes.dart';
import '../database/methods.dart';
import '../database/variables.dart';
import '../database/theme.dart';

class ChooseScreen extends StatelessWidget {
  const ChooseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(seDarkBlue),
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
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Color(seLightBlue),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: seBorderWidth,
          color: Color(seBlue),
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
          const Expanded(
            child: Text(
              'CHOOSE CHARACTERS',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          TopBarButton(
            text: "DONE",
            onTapAction: () {
              saveSelectedChars();
              Navigator.pushReplacementNamed(context, '/gamescreen');
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
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

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
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: seBorderWidth,
          color: Color(seLightGrey),
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
                color: Color(seDarkBlue),
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

// CHARACTER NAME AND PICTURE BOX
class CharSelectionBox extends StatefulWidget {
  final int index;

  const CharSelectionBox({
    Key? key,
    required this.index,
  }) : super(key: key);
  @override
  State<CharSelectionBox> createState() => _CharSelectionBoxState();
}

class _CharSelectionBoxState extends State<CharSelectionBox> {
  var counter = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Character>(
      future: DatabaseService().getOnlyChar((widget.index) * 5 + counter),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            child: const Text(
              'Loading...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          );
        } else {
          var char = snapshot.data!;
          selectedChars[widget.index].charID = char.charID;
          selectedChars[widget.index].charName = char.charName;
          selectedChars[widget.index].imgURL = char.imgURL;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                child: ArrowButton(
                  text: '<',
                  onTapAction: () {
                    if (counter == 0) {
                      counter = 4;
                    } else {
                      counter--;
                    }
                    setState(() {});
                  },
                  buttonColor: sePinkyRed,
                  borderColor: seDarkPinkyRed,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(3),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Color(seLightCream),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      width: seBorderWidth,
                      color: Color(seCream),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: seBorderWidth,
                                  color: Color(seDarkCream),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(
                                    char.imgURL!,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          char.charName!,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(seDarkPinkyRed),
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
                child: ArrowButton(
                  text: '>',
                  onTapAction: () {
                    if (counter == 4) {
                      counter = 0;
                    } else {
                      counter++;
                    }
                    setState(() {});
                  },
                  buttonColor: sePinkyRed,
                  borderColor: seDarkPinkyRed,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

// CHARACTER NAME AND PICTURE BOX
class SkillSelectionBox extends StatefulWidget {
  final int index;
  const SkillSelectionBox({
    Key? key,
    required this.index,
  }) : super(key: key);
  @override
  State<SkillSelectionBox> createState() => _SkillSelectionBoxState();
}

class _SkillSelectionBoxState extends State<SkillSelectionBox> {
  var counter = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Character>(
      future: DatabaseService().getOnlySkill(counter),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          var char = snapshot.data!;
          selectedChars[widget.index].skillID = char.skillID;
          selectedChars[widget.index].skillName = char.skillName;
          selectedChars[widget.index].skillDesc = char.skillDesc;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                child: ArrowButton(
                  text: '<',
                  onTapAction: () {
                    if (counter == 0) {
                      counter = 9;
                    } else {
                      counter--;
                    }
                    setState(() {});
                  },
                  buttonColor: seLightBlue,
                  borderColor: seBlue,
                ),
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SkillDescAlertBox(
                          skillName: char.skillName!,
                          skillDesc: char.skillDesc!,
                        );
                      },
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Color(seLightGrey),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        width: seBorderWidth,
                        color: Color(seGrey),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'The\n${char.skillName!}',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(3),
                child: ArrowButton(
                  text: '>',
                  onTapAction: () {
                    if (counter == 9) {
                      counter = 0;
                    } else {
                      counter++;
                    }
                    setState(() {});
                  },
                  buttonColor: seLightBlue,
                  borderColor: seBlue,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

// SKILL DESCRIPTION BOX
class SkillDescAlertBox extends StatelessWidget {
  final String skillName;
  final String skillDesc;
  const SkillDescAlertBox({
    Key? key,
    required this.skillName,
    required this.skillDesc,
  }) : super(key: key);

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
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            width: seBorderWidth,
            color: Color(seGrey),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      skillName,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: const MenuCloseButton(),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(5),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Text(
                  skillDesc,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// BUTTONS
class ArrowButton extends StatelessWidget {
  final String text;
  final VoidCallback onTapAction;
  final int buttonColor;
  final int borderColor;
  const ArrowButton({
    Key? key,
    required this.text,
    required this.onTapAction,
    required this.buttonColor,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapAction,
      child: Container(
        alignment: Alignment.center,
        width: 40,
        decoration: BoxDecoration(
          color: Color(buttonColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: seBorderWidth,
            color: Color(borderColor),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 35,
          ),
        ),
      ),
    );
  }
}

class MenuCloseButton extends StatelessWidget {
  const MenuCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        // SAVE GAME AND GO BACK TO MAIN MENU
      },
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Color(seLightGrey),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: seBorderWidth,
            color: Color(seGrey),
          ),
        ),
        child: Text(
          'X',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Color(seDarkPinkyRed),
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
