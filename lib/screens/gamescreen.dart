import 'dart:async';

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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/shuttlefly_effect_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: SEColors().black,
                border: Border(
                  right: BorderSide(
                    width: seBorderWidth,
                    color: SEColors().lblack,
                  ),
                ),
              ),
              child: Column(
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
                                    animationTimer!.cancel();
                                    Navigator.pushReplacementNamed(
                                        context, '/homescreen');
                                  },
                                  height: 50,
                                  textColor: SEColors().white,
                                  buttonColor: SEColors().lblue,
                                  borderColor: SEColors().blue,
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
                                              textColor: SEColors().white,
                                              buttonColor: SEColors().lblue,
                                              borderColor: SEColors().blue,
                                            ),
                                            AnyButton(
                                              text: 'YES',
                                              onTapAction: () async {
                                                animationTimer!.cancel();
                                                Navigator.pushReplacementNamed(
                                                    context, '/choosescreen');
                                                restartTheGame();
                                              },
                                              height: 50,
                                              textColor: SEColors().white,
                                              buttonColor: SEColors().lred,
                                              borderColor: SEColors().red,
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  height: 50,
                                  textColor: SEColors().white,
                                  buttonColor: SEColors().lred,
                                  borderColor: SEColors().red,
                                ),
                              ],
                            );
                          },
                        );
                      },
                      height: 50,
                      width: 150,
                      textColor: SEColors().white,
                      buttonColor: SEColors().lblue,
                      borderColor: SEColors().blue,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: StateValueBox(
                                text: 'Health',
                                value: currentStates.health,
                                width: 150,
                                textColor: SEColors().white,
                                boxColor: (currentSelection != null &&
                                        currentSelection!.healthChange != 0)
                                    ? SEColors().lred
                                    : SEColors().dgrey2,
                                bgColor: (currentSelection != null &&
                                        currentSelection!.healthChange != 0)
                                    ? SEColors().dred
                                    : SEColors().dblack,
                                borderColor: (currentSelection != null &&
                                        currentSelection!.healthChange != 0)
                                    ? SEColors().red
                                    : SEColors().lblack,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: StateValueBox(
                                text: 'Oxygen',
                                value: currentStates.oxygen,
                                width: 150,
                                textColor: SEColors().white,
                                boxColor: (currentSelection != null &&
                                        currentSelection!.oxygenChange != 0)
                                    ? SEColors().lblue
                                    : SEColors().dgrey2,
                                bgColor: (currentSelection != null &&
                                        currentSelection!.oxygenChange != 0)
                                    ? SEColors().dblue
                                    : SEColors().dblack,
                                borderColor: (currentSelection != null &&
                                        currentSelection!.oxygenChange != 0)
                                    ? SEColors().blue
                                    : SEColors().lblack,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: StateValueBox(
                                text: 'Morale',
                                value: currentStates.morale,
                                width: 150,
                                textColor: SEColors().white,
                                boxColor: (currentSelection != null &&
                                        currentSelection!.moraleChange != 0)
                                    ? SEColors().lpurple
                                    : SEColors().dgrey2,
                                bgColor: (currentSelection != null &&
                                        currentSelection!.moraleChange != 0)
                                    ? SEColors().dpurple
                                    : SEColors().dblack,
                                borderColor: (currentSelection != null &&
                                        currentSelection!.moraleChange != 0)
                                    ? SEColors().purple
                                    : SEColors().lblack,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: StateValueBox(
                                text: 'Energy',
                                value: currentStates.energy,
                                width: 150,
                                textColor: SEColors().white,
                                boxColor: (currentSelection != null &&
                                        currentSelection!.energyChange != 0)
                                    ? SEColors().lyellow
                                    : SEColors().dgrey2,
                                bgColor: (currentSelection != null &&
                                        currentSelection!.energyChange != 0)
                                    ? SEColors().dyellow
                                    : SEColors().dblack,
                                borderColor: (currentSelection != null &&
                                        currentSelection!.energyChange != 0)
                                    ? SEColors().yellow
                                    : SEColors().lblack,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: AnimatedShip(
                          notifyParent: refresh,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          (eventIsWaiting)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (int i = 0; i < 3; i++)
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          child: CharBox(
                                            index: i,
                                            height: 70,
                                            textColor: SEColors().white,
                                            boxColor: SEColors().blue,
                                            imgBgColor: SEColors().lblue,
                                            borderColor: SEColors().dblue,
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              : Container(
                                  padding: const EdgeInsets.all(5),
                                  child: AnyButton(
                                    text: 'DONE',
                                    onTapAction: () async {
                                      String? message = checkStates();
                                      if (message == null) {
                                        currentEvent = await getRandomEvent();
                                        await SharedPrefsService()
                                            .saveEventID();
                                        currentSelection = null;
                                        eventIsWaiting = true;
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
                                                    animationTimer!.cancel();
                                                    Navigator
                                                        .pushReplacementNamed(
                                                            context,
                                                            '/homescreen');
                                                  },
                                                  height: 50,
                                                  textColor: SEColors().white,
                                                  buttonColor: SEColors().lblue,
                                                  borderColor: SEColors().blue,
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    height: 50,
                                    textColor: SEColors().white,
                                    buttonColor: SEColors().lred,
                                    borderColor: SEColors().red,
                                  ),
                                ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: EventBox(
                              title: currentEvent!.title,
                              desc: currentEvent!.desc,
                              height: 120,
                              textColor: SEColors().white,
                              boxColor: SEColors().dblack,
                              borderColor: SEColors().lblack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
  final Color textColor;
  final Color boxColor;
  final Color bgColor;
  final Color borderColor;
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
        color: widget.bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: seBorderWidth,
          color: widget.borderColor,
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          AnimatedContainer(
            width: (widget.width != null)
                ? (widget.width! - 10) *
                    (widget.value - minStateValue) /
                    (maxtStateValue - minStateValue)
                : null,
            decoration: BoxDecoration(
              color: widget.boxColor,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCirc,
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    child: Text(
                      "%${widget.value}",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
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
  final double? width;
  final double? height;
  final Color textColor;
  final Color boxColor;
  final Color borderColor;
  const EventBox({
    super.key,
    required this.title,
    required this.desc,
    this.width,
    this.height,
    required this.textColor,
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
      alignment: Alignment.center,
      height: (widget.height != null) ? widget.height : null,
      width: (widget.width != null) ? widget.width : null,
      decoration: BoxDecoration(
        color: widget.boxColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Text(
            (eventIsWaiting)
                ? "${currentEvent!.title} ${currentEvent!.desc}"
                : "The Result: ${currentSelection!.desc}",
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

// CHARACTER BOX
class CharBox extends StatelessWidget {
  final int index;
  final double? height;
  final double? width;
  final Color textColor;
  final Color boxColor;
  final Color imgBgColor;
  final Color borderColor;

  const CharBox({
    super.key,
    required this.index,
    this.height,
    this.width,
    required this.textColor,
    required this.boxColor,
    required this.imgBgColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (height != null) ? height : null,
      width: (width != null) ? width : null,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: seBorderWidth,
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          Draggable<int>(
            data: index,
            feedback: SizedBox(
              height: (height != null)
                  ? height
                  : (width != null)
                      ? width
                      : 70,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: imgBgColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        join("assets", "images", selectedChars[index]!.imgName),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            childWhenDragging: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: imgBgColor,
                ),
              ),
            ),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: imgBgColor,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      join("assets", "images", selectedChars[index]!.imgName),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                '${selectedChars[index]!.name} The ${selectedSkills[index]!.name}',
                textAlign: TextAlign.left,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ANIMATED SHIP BOX
class AnimatedShip extends StatefulWidget {
  final Function() notifyParent;
  const AnimatedShip({
    super.key,
    required this.notifyParent,
  });

  @override
  State<AnimatedShip> createState() => _AnimatedShipState();
}

class _AnimatedShipState extends State<AnimatedShip> {
  bool animationState = true;

  @override
  void initState() {
    super.initState();
    animationTimer = Timer.periodic(
      const Duration(seconds: 1, milliseconds: 500),
      (dataTimer) => setState(() {
        animationState = !animationState;
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationTimer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: animationState
          ? const EdgeInsets.only(bottom: 30)
          : const EdgeInsets.only(top: 30),
      duration: const Duration(seconds: 1, milliseconds: 500),
      curve: Curves.easeInOut,
      child: DragTarget<int>(
        builder: (
          BuildContext context,
          List<dynamic> accepted,
          List<dynamic> rejected,
        ) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/shuttlefly_effect_logo.png'),
              ),
            ),
          );
        },
        onMove: (details) async {
          currentSelection ??= await SQLiteServices().getSelection(
            currentEvent!.id,
            selectedSkills[details.data]!.id,
            selectedChars[details.data]!.name,
          );
          widget.notifyParent();
        },
        onLeave: (data) {
          currentSelection = null;
          widget.notifyParent();
        },
        onAccept: (data) async {
          manageStates();
          eventIsWaiting = false;
          await SharedPrefsService().saveStates();
          widget.notifyParent();
        },
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

// BUTTON
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
