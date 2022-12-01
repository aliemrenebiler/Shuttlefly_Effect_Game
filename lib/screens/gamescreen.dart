import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'allglobalwidgets.dart';
import '../backend/methods.dart';
import '../backend/theme.dart';

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
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return const PauseMenu();
          },
        );
      },
      child: Scaffold(
        body: ContainerWithBG(
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height / 60),
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height / 60),
                  // ignore: prefer_const_constructors
                  child: GameScreenTopBar(),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height / 60),
                                height: MediaQuery.of(context).size.height / 3,
                                child: AnimatedShip(
                                  notifyParent: refresh,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.height / 30),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Galaxy #${currentGalaxy.id}",
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: SEColors().white,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height / 60),
                                child: EventBox(
                                  title: currentEvent!.title,
                                  desc: currentEvent!.desc,
                                  titleColor: SEColors().lyellow2,
                                  textColor: SEColors().white,
                                  boxColor: SEColors().black,
                                  borderColor: SEColors().lblack,
                                ),
                              ),
                            ),
                            (eventIsWaiting)
                                ? Row(
                                    children: [
                                      for (int i = 0; i < 3; i++)
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    120),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          120),
                                                  child: CharBox(
                                                    index: i,
                                                    textColor: SEColors().white,
                                                    boxColor: SEColors().red,
                                                    imgBgColor: SEColors().dred,
                                                    borderColor:
                                                        SEColors().lred,
                                                    imgBorderColor:
                                                        SEColors().dred,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          120),
                                                  child: ProfBox(
                                                    index: i,
                                                    textColor: SEColors().white,
                                                    boxColor: SEColors().blue,
                                                    borderColor:
                                                        SEColors().lblue,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                : Container(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.height /
                                            120),
                                    child: DoneButton(
                                      notifyParent: refresh,
                                    ),
                                  ),
                          ],
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
class GameScreenTopBar extends StatelessWidget {
  const GameScreenTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TopBar(
      widgets: [
        TopBarButton(
          text: "MENU",
          onTapAction: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const PauseMenu();
              },
            );
          },
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height / 120),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height / 120),
                  child: StateValueBox(
                    text: 'Health',
                    value: currentStates.health,
                    width: MediaQuery.of(context).size.width / 6,
                    textColor: SEColors().white,
                    boxColor: (currentResult != null &&
                            currentResult!.healthChange != 0)
                        ? SEColors().lred
                        : SEColors().dgrey2,
                    bgColor: (currentResult != null &&
                            currentResult!.healthChange != 0)
                        ? SEColors().dred
                        : SEColors().dblack,
                    borderColor: (currentResult != null &&
                            currentResult!.healthChange != 0)
                        ? SEColors().red
                        : SEColors().lblack,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height / 120),
                  child: StateValueBox(
                    text: 'Morale',
                    value: currentStates.morale,
                    width: MediaQuery.of(context).size.width / 6,
                    textColor: SEColors().white,
                    boxColor: (currentResult != null &&
                            currentResult!.moraleChange != 0)
                        ? SEColors().lpurple
                        : SEColors().dgrey2,
                    bgColor: (currentResult != null &&
                            currentResult!.moraleChange != 0)
                        ? SEColors().dpurple
                        : SEColors().dblack,
                    borderColor: (currentResult != null &&
                            currentResult!.moraleChange != 0)
                        ? SEColors().purple
                        : SEColors().lblack,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height / 120),
                  child: StateValueBox(
                    text: 'Oxygen',
                    value: currentStates.oxygen,
                    width: MediaQuery.of(context).size.width / 6,
                    textColor: SEColors().white,
                    boxColor: (currentResult != null &&
                            currentResult!.oxygenChange != 0)
                        ? SEColors().lblue
                        : SEColors().dgrey2,
                    bgColor: (currentResult != null &&
                            currentResult!.oxygenChange != 0)
                        ? SEColors().dblue
                        : SEColors().dblack,
                    borderColor: (currentResult != null &&
                            currentResult!.oxygenChange != 0)
                        ? SEColors().blue
                        : SEColors().lblack,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height / 120),
                  child: StateValueBox(
                    text: 'Source',
                    value: currentStates.source,
                    width: MediaQuery.of(context).size.width / 6,
                    textColor: SEColors().white,
                    boxColor: (currentResult != null &&
                            currentResult!.sourceChange != 0)
                        ? SEColors().lyellow
                        : SEColors().dgrey2,
                    bgColor: (currentResult != null &&
                            currentResult!.sourceChange != 0)
                        ? SEColors().dyellow
                        : SEColors().dblack,
                    borderColor: (currentResult != null &&
                            currentResult!.sourceChange != 0)
                        ? SEColors().yellow
                        : SEColors().lblack,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

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
        alignment: Alignment.centerLeft,
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
              padding: EdgeInsets.all(MediaQuery.of(context).size.height / 120),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: MediaQuery.of(context).size.height / 30,
                      ),
                    ),
                  ),
                  Text(
                    "%${widget.value}",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: MediaQuery.of(context).size.height / 25,
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

// ANIMATED SHIP BOX
class AnimatedShip extends StatelessWidget {
  final Function() notifyParent;
  const AnimatedShip({
    super.key,
    required this.notifyParent,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: flowAnimationStream,
      builder: (context, snapshot) {
        return AnimatedContainer(
          padding: flowAnimationState
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
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(
                      join("assets", "images", "shuttlefly_effect_ship.png"),
                    ),
                  ),
                ),
              );
            },
            onMove: (details) async {
              currentResult ??= await SQLiteServices().getResult(
                currentGalaxy.id,
                currentEvent!.id,
                selectedProfs[details.data]!.id,
                selectedChars[details.data]!.name,
              );
              notifyParent();
            },
            onLeave: (data) {
              currentResult = null;
              notifyParent();
            },
            onAccept: (data) async {
              currentEnding =
                  await SQLiteServices().getEnding(currentResult!.endingID);
              manageStates();
              eventIsWaiting = false;
              await SharedPrefsService().saveStates();
              checkStates(
                currentEnding!.healthCondition,
                currentEnding!.moraleCondition,
                currentEnding!.oxygenCondition,
                currentEnding!.sourceCondition,
              );
              notifyParent();
            },
          ),
        );
      },
    );
  }
}

// BOXES
class EventBox extends StatelessWidget {
  final String title;
  final String desc;
  final double? width;
  final double? height;
  final Color titleColor;
  final Color textColor;
  final Color boxColor;
  final Color borderColor;
  const EventBox({
    super.key,
    required this.title,
    required this.desc,
    this.width,
    this.height,
    required this.titleColor,
    required this.textColor,
    required this.boxColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.all(MediaQuery.of(context).size.height / 20),
          child: RichText(
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: (eventIsWaiting)
                  ? <TextSpan>[
                      TextSpan(
                        text: currentEvent!.title,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: MediaQuery.of(context).size.height / 20,
                        ),
                      ),
                      TextSpan(
                        text: " ${currentEvent!.desc}",
                        style: TextStyle(
                          color: textColor,
                          fontSize: MediaQuery.of(context).size.height / 20,
                        ),
                      ),
                    ]
                  : <TextSpan>[
                      TextSpan(
                        text: currentResult!.desc,
                        style: TextStyle(
                          color: textColor,
                          fontSize: MediaQuery.of(context).size.height / 20,
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

class CharBox extends StatelessWidget {
  final int index;
  final double? height;
  final double? width;
  final Color textColor;
  final Color boxColor;
  final Color imgBgColor;
  final Color borderColor;
  final Color imgBorderColor;
  const CharBox({
    super.key,
    required this.index,
    this.height,
    this.width,
    required this.textColor,
    required this.boxColor,
    required this.imgBgColor,
    required this.borderColor,
    required this.imgBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (height != null) ? height : null,
      width: (width != null) ? width : null,
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 120),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: seBorderWidth,
          color: borderColor,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Draggable<int>(
            data: index,
            feedback: SizedBox(
              width: MediaQuery.of(context).size.height / 6,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: SEColors().red,
                    border: Border.all(
                      width: seBorderWidth,
                      color: SEColors().dred,
                    ),
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
            childWhenDragging: Container(
              margin: EdgeInsets.all(MediaQuery.of(context).size.height / 120),
              width: MediaQuery.of(context).size.height / 6,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  width: MediaQuery.of(context).size.height / 6,
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.height / 120),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: imgBgColor,
                    border: Border.all(
                      width: seBorderWidth,
                      color: imgBorderColor,
                    ),
                  ),
                ),
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(MediaQuery.of(context).size.height / 120),
              width: MediaQuery.of(context).size.height / 6,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: SEColors().red,
                    border: Border.all(
                      width: seBorderWidth,
                      color: SEColors().dred,
                    ),
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
          ),
          Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height / 120),
            alignment: Alignment.center,
            child: Text(
              selectedChars[index]!.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: SEColors().white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfBox extends StatelessWidget {
  final int index;
  final Color textColor;
  final Color boxColor;
  final Color borderColor;
  const ProfBox({
    super.key,
    required this.index,
    required this.textColor,
    required this.boxColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopUpAlertBox(
              alertTitle: selectedProfs[index]!.name,
              alertDesc: selectedProfs[index]!.desc,
              titleColor: SEColors().lyellow2,
              textColor: SEColors().white,
              boxColor: SEColors().black,
              borderColor: SEColors().lblack,
              closeButton: const AlertCloseButton(),
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height / 120),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: seBorderWidth,
            color: borderColor,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          selectedProfs[index]!.name,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

// DONE BUTTON
class DoneButton extends StatelessWidget {
  final Function() notifyParent;
  const DoneButton({
    super.key,
    required this.notifyParent,
  });

  @override
  Widget build(BuildContext context) {
    return AnyButton(
      text: 'DONE',
      onTapAction: () async {
        String? message = checkStates(
          currentEnding!.healthCondition,
          currentEnding!.moraleCondition,
          currentEnding!.oxygenCondition,
          currentEnding!.sourceCondition,
        );
        if (message == null) {
          currentEvent = await getRandomEvent(currentGalaxy.id);
          await SharedPrefsService().saveEventID();
          currentResult = null;
          eventIsWaiting = true;
          notifyParent();
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return PopUpAlertBox(
                alertTitle: 'THE END',
                alertDesc: message,
                titleColor: SEColors().lyellow2,
                textColor: SEColors().white,
                boxColor: SEColors().black,
                borderColor: SEColors().lblack,
                buttons: [
                  AnyButton(
                    text: 'MAIN MENU',
                    onTapAction: () {
                      Navigator.pushReplacementNamed(context, '/homescreen');
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
      height: 40,
      textColor: SEColors().white,
      buttonColor: SEColors().lred,
      borderColor: SEColors().red,
    );
  }
}

// PAUSE MENU
class PauseMenu extends StatelessWidget {
  const PauseMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopUpAlertBox(
      alertTitle: 'PAUSED',
      titleColor: SEColors().lyellow2,
      textColor: SEColors().white,
      boxColor: SEColors().black,
      borderColor: SEColors().lblack,
      closeButton: const AlertCloseButton(),
      buttons: [
        AnyButton(
          text: 'MAIN MENU',
          onTapAction: () {
            Navigator.pushReplacementNamed(context, '/homescreen');
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
                  alertDesc: 'Your previous progress will be deleted.',
                  titleColor: SEColors().lyellow2,
                  textColor: SEColors().white,
                  boxColor: SEColors().black,
                  borderColor: SEColors().lblack,
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
  }
}
