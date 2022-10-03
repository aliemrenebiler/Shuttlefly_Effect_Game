import 'package:flutter/material.dart';

import '../database/classes.dart';
import '../database/methods.dart';
import '../database/variables.dart';
import '../database/theme.dart';

class ChooseScreen extends StatelessWidget {
  const ChooseScreen({super.key});

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
  const TopBar({super.key});

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
          Expanded(
            child: Text(
              'CHOOSE CHARACTERS',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(seWhite),
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
          style: TextStyle(
            color: Color(seWhite),
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
        color: Color(seWhite),
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
  var counter = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Character>(
      future: DatabaseService().getOnlyChar((widget.index) * 5 + counter),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              'Loading...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(seLightBlue),
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
                child: AnyButton(
                  text: '<',
                  onTapAction: () {
                    if (counter == 0) {
                      counter = 4;
                    } else {
                      counter--;
                    }
                    setState(() {});
                  },
                  width: 35,
                  textColor: seWhite,
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
                                color: Color(seGrey),
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
                child: AnyButton(
                  text: '>',
                  onTapAction: () {
                    if (counter == 4) {
                      counter = 0;
                    } else {
                      counter++;
                    }
                    setState(() {});
                  },
                  width: 35,
                  textColor: seWhite,
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
                child: AnyButton(
                  text: '<',
                  onTapAction: () {
                    if (counter == 0) {
                      counter = 9;
                    } else {
                      counter--;
                    }
                    setState(() {});
                  },
                  width: 35,
                  textColor: seWhite,
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
                        return PopUpAlertBox(
                          alertTitle: char.skillName!,
                          alertDesc: char.skillDesc!,
                          closeButtonActive: true,
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
                child: AnyButton(
                  text: '>',
                  onTapAction: () {
                    if (counter == 9) {
                      counter = 0;
                    } else {
                      counter++;
                    }
                    setState(() {});
                  },
                  width: 35,
                  textColor: seWhite,
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
          color: Color(seWhite),
          borderRadius: BorderRadius.circular(10),
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
                      textColor: seDarkPinkyRed,
                      buttonColor: seLightGrey,
                      borderColor: seGrey,
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
  final int textColor;
  final int buttonColor;
  final int borderColor;
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
          style: TextStyle(
            color: Color(textColor),
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
