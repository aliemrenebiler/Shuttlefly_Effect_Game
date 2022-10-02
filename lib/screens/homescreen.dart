import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../database/methods.dart';
import '../database/variables.dart';
import '../database/theme.dart';

Timer? animationTimer;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/shuttlefly_effect_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: AnimatedLogo(
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 3.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: FixedHeightButton(
                      text: 'NEW GAME',
                      onTapAction: () async {
                        if (await DatabaseService().dataExists) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PopUpAlertBox(
                                alertTitle: 'ARE YOU SURE?',
                                alertDesc:
                                    'Your previous progress will be deleted.',
                                closeButtonActive: false,
                                buttons: [
                                  FixedHeightButton(
                                    text: 'NO',
                                    onTapAction: () {
                                      Navigator.pop(context);
                                    },
                                    textColor: seWhite,
                                    buttonColor: seLightBlue,
                                    borderColor: seBlue,
                                  ),
                                  FixedHeightButton(
                                    text: 'YES',
                                    onTapAction: () async {
                                      Navigator.popAndPushNamed(
                                          context, '/storyscreen');
                                      animationTimer!.cancel();
                                      await DatabaseService().eraseSavedData();
                                    },
                                    textColor: seWhite,
                                    buttonColor: sePinkyRed,
                                    borderColor: seDarkPinkyRed,
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.pushNamed(context, '/storyscreen');
                          animationTimer!.cancel();
                        }
                      },
                      textColor: seWhite,
                      buttonColor: seLightBlue,
                      borderColor: seBlue,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: FixedHeightButton(
                      text: 'CONTINUE',
                      onTapAction: () async {
                        if (await DatabaseService().dataExists) {
                          Navigator.pushReplacementNamed(
                              context, '/gamescreen');
                          animationTimer!.cancel();
                          selectedChars[0] =
                              await DatabaseService().getCharFromLocal(1);
                          selectedChars[1] =
                              await DatabaseService().getCharFromLocal(2);
                          selectedChars[2] =
                              await DatabaseService().getCharFromLocal(3);

                          event.eventID =
                              await DatabaseService().getEventIDFromLocal();
                          event =
                              await DatabaseService().getEvent(event.eventID!);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const PopUpAlertBox(
                                alertTitle: 'NO DATA!',
                                alertDesc:
                                    'There is no progress saved.\nYou should start a new game.',
                                closeButtonActive: true,
                              );
                            },
                          );
                        }
                      },
                      textColor: seWhite,
                      buttonColor: sePinkyRed,
                      borderColor: seDarkPinkyRed,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: FixedHeightButton(
                      text: 'EXIT',
                      onTapAction: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PopUpAlertBox(
                              alertTitle: 'LEAVING?',
                              closeButtonActive: false,
                              buttons: [
                                FixedHeightButton(
                                  text: 'NO',
                                  onTapAction: () {
                                    Navigator.pop(context);
                                  },
                                  textColor: seWhite,
                                  buttonColor: seLightBlue,
                                  borderColor: seBlue,
                                ),
                                FixedHeightButton(
                                  text: 'YES',
                                  onTapAction: () {
                                    animationTimer!.cancel();
                                    SystemNavigator.pop(); // EXIT
                                  },
                                  textColor: seWhite,
                                  buttonColor: sePinkyRed,
                                  borderColor: seDarkPinkyRed,
                                ),
                              ],
                            );
                          },
                        );
                      },
                      textColor: seWhite,
                      buttonColor: seGrey,
                      borderColor: seDarkGrey,
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

// ANIMATED LOGO
class AnimatedLogo extends StatefulWidget {
  final double width;
  const AnimatedLogo({super.key, required this.width});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> {
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
      child: Container(
        width: widget.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage('assets/shuttlefly_effect_logo.png'),
          ),
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
    Key? key,
    required this.alertTitle,
    this.alertDesc,
    required this.closeButtonActive,
    this.buttons,
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
                    child: SquareButton(
                      text: 'X',
                      onTapAction: () {
                        Navigator.pop(context);
                      },
                      textColor: seDarkPinkyRed,
                      buttonColor: seLightGrey,
                      borderColor: seGrey,
                    ),
                  ),
              ],
            ),
            if (alertDesc != null)
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(5),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    alertDesc!,
                    textAlign: TextAlign.left,
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
class FixedHeightButton extends StatelessWidget {
  final String text;
  final VoidCallback onTapAction;
  final int textColor;
  final int buttonColor;
  final int borderColor;
  const FixedHeightButton({
    Key? key,
    required this.text,
    required this.onTapAction,
    required this.textColor,
    required this.buttonColor,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapAction,
      child: Container(
        alignment: Alignment.center,
        height: 50,
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

class SquareButton extends StatelessWidget {
  final String text;
  final VoidCallback onTapAction;
  final int textColor;
  final int buttonColor;
  final int borderColor;
  const SquareButton({
    Key? key,
    required this.text,
    required this.onTapAction,
    required this.textColor,
    required this.buttonColor,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapAction,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: 50,
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
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
