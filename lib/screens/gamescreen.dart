import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../database/methods.dart';
import '../database/variables.dart';
import '../database/theme.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(seDarkBlue),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: EventBox(
                  title: currentEvent!.title,
                  desc: currentEvent!.desc,
                  titleColor: seDarkBlue,
                  descColor: seBlack,
                  boxColor: seWhite,
                  borderColor: seLightGrey,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: AnyButton(
                      text: 'MENU',
                      onTapAction: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PopUpAlertBox(
                              alertTitle: 'PAUSED',
                              closeButtonActive: true,
                              buttons: [
                                AnyButton(
                                  text: 'MAIN MENU',
                                  onTapAction: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/homescreen');
                                  },
                                  height: 50,
                                  textColor: seWhite,
                                  buttonColor: seLightBlue,
                                  borderColor: seBlue,
                                ),
                                AnyButton(
                                  text: 'RESTART',
                                  onTapAction: () {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PopUpAlertBox(
                                          alertTitle: 'ARE YOU SURE?',
                                          alertDesc:
                                              'Your previous progress will be deleted.',
                                          closeButtonActive: false,
                                          buttons: [
                                            AnyButton(
                                              text: 'NO',
                                              onTapAction: () {
                                                Navigator.pop(context);
                                              },
                                              height: 50,
                                              textColor: seWhite,
                                              buttonColor: seLightBlue,
                                              borderColor: seBlue,
                                            ),
                                            AnyButton(
                                              text: 'YES',
                                              onTapAction: () async {
                                                Navigator.pushReplacementNamed(
                                                    context, '/choosescreen');
                                                restartTheGame();
                                              },
                                              height: 50,
                                              textColor: seWhite,
                                              buttonColor: seLightPinkyRed,
                                              borderColor: sePinkyRed,
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  height: 50,
                                  textColor: seWhite,
                                  buttonColor: seLightPinkyRed,
                                  borderColor: sePinkyRed,
                                ),
                              ],
                            );
                          },
                        );
                      },
                      height: 50,
                      textColor: seWhite,
                      buttonColor: seLightBlue,
                      borderColor: seBlue,
                    ),
                  ),
                  (eventPageIndex == 0)
                      ? Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                for (int i = 0; i < 3; i++)
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: CharBox(
                                        index: i,
                                        onTapAction: () async {
                                          if (eventPageIndex != 1) {
                                            currentSelection =
                                                await SQLiteServices()
                                                    .getSelection(
                                              currentEvent!.id,
                                              selectedSkills[i]!.id,
                                              selectedChars[i]!.name,
                                            );
                                            manageStates();
                                            eventPageIndex = 1;
                                            await SharedPrefsService()
                                                .saveStates();
                                            refresh();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(10),
                          child: AnyButton(
                            text: 'DONE',
                            onTapAction: () async {
                              String? message = checkStates();
                              if (message == null) {
                                currentEvent = await getRandomEvent();
                                await SharedPrefsService().saveEventID();
                                eventPageIndex = 0;
                                refresh();
                              } else {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return PopUpAlertBox(
                                      alertTitle: 'THE END',
                                      alertDesc: message,
                                      closeButtonActive: false,
                                      buttons: [
                                        AnyButton(
                                          text: 'MAIN MENU',
                                          onTapAction: () {
                                            Navigator.pushReplacementNamed(
                                                context, '/homescreen');
                                          },
                                          height: 50,
                                          textColor: seWhite,
                                          buttonColor: seLightBlue,
                                          borderColor: seBlue,
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            height: 50,
                            textColor: seWhite,
                            buttonColor: seLightPinkyRed,
                            borderColor: sePinkyRed,
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

// STATE VALUE BOX
class StateValueBox extends StatefulWidget {
  final String text;
  final int value;
  final double? width;
  final double? height;
  final int textColor;
  final int boxColor;
  final int bgColor;
  final int borderColor;
  const StateValueBox({
    super.key,
    required this.text,
    required this.value,
    this.width,
    this.height,
    required this.textColor,
    required this.boxColor,
    required this.bgColor,
    required this.borderColor,
  });

  @override
  State<StateValueBox> createState() => _StateValueBoxState();
}

class _StateValueBoxState extends State<StateValueBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (widget.height != null) ? widget.height : null,
      width: (widget.width != null) ? widget.width : null,
      decoration: BoxDecoration(
        color: Color(widget.bgColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: seBorderWidth,
          color: Color(widget.borderColor),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AnimatedContainer(
            height: (widget.height != null)
                ? (widget.height! - 10) *
                    (widget.value - minStateValue) /
                    (maxtStateValue - minStateValue)
                : null,
            decoration: BoxDecoration(
              color: Color(widget.boxColor),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCirc,
          ),
          Container(
            padding: const EdgeInsets.all(3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(widget.textColor),
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    '${widget.value}',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(widget.textColor),
                      fontSize: 20,
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

// EVENT BOX
class EventBox extends StatefulWidget {
  final String title;
  final String desc;
  final int titleColor;
  final int descColor;
  final int boxColor;
  final int borderColor;
  const EventBox({
    super.key,
    required this.title,
    required this.desc,
    required this.titleColor,
    required this.descColor,
    required this.boxColor,
    required this.borderColor,
  });

  @override
  State<EventBox> createState() => _EventBoxState();
}

class _EventBoxState extends State<EventBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(widget.boxColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: seBorderWidth,
          color: Color(widget.borderColor),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(15, 20, 15, 10),
            child: Text(
              (eventPageIndex != 1) ? currentEvent!.title : 'WHAT HAPPENED?',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(widget.titleColor),
                fontSize: 25,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Text(
                  (eventPageIndex != 1)
                      ? currentEvent!.desc
                      : currentSelection!.desc,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Color(widget.descColor),
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(3),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    child: StateValueBox(
                      text: 'Health',
                      value: currentStates.health,
                      height: 80,
                      textColor: seWhite,
                      boxColor: seLightPinkyRed,
                      bgColor: seDarkPinkyRed,
                      borderColor: sePinkyRed,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    child: StateValueBox(
                      text: 'Oxygen',
                      value: currentStates.oxygen,
                      height: 80,
                      textColor: seWhite,
                      boxColor: seLightBlue,
                      bgColor: seDarkBlue,
                      borderColor: seBlue,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    child: StateValueBox(
                      text: 'Morale',
                      value: currentStates.morale,
                      height: 80,
                      textColor: seWhite,
                      boxColor: seLightPurple,
                      bgColor: seDarkPurple,
                      borderColor: sePurple,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    child: StateValueBox(
                      text: 'Energy',
                      value: currentStates.energy,
                      height: 80,
                      textColor: seWhite,
                      boxColor: seLightYellow,
                      bgColor: seDarkYellow,
                      borderColor: seYellow,
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

// CHARACTER BOX
class CharBox extends StatelessWidget {
  final int index;
  final double? height;
  final double? width;
  final Function() onTapAction;

  const CharBox({
    super.key,
    required this.index,
    this.height,
    this.width,
    required this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapAction,
      child: Container(
        height: (height != null) ? height : null,
        width: (width != null) ? width : null,
        decoration: BoxDecoration(
          color: Color(seLightCream),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: seBorderWidth,
            color: Color(seCream),
          ),
        ),
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 80,
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage(
                        join(
                          "assets",
                          "images",
                          selectedChars[index]!.imgName,
                        ),
                      ),
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: seBorderWidth,
                      color: Color(seDarkCream),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(3),
                child: Text(
                  '${selectedChars[index]!.name} The ${selectedSkills[index]!.name}',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Color(sePinkyRed),
                    fontSize: 18,
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
                      textColor: sePinkyRed,
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
