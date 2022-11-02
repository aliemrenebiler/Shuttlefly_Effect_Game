import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../database/methods.dart';
import '../database/variables.dart';
import '../database/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        child: FutureBuilder<Database>(
          future: SQLiteServices().copyAndOpenDB("shuttlefly_db.db"),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  'Loading...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: SEColors().white,
                    fontSize: 30,
                  ),
                ),
              );
            } else {
              database = snapshot.data;
              return Row(
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
                          child: AnyButton(
                            text: 'NEW GAME',
                            onTapAction: () async {
                              if (await SharedPrefsService().dataExists) {
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
                                          onTapAction: () {
                                            animationTimer!.cancel();
                                            Navigator.pushReplacementNamed(
                                                context, '/storyscreen');
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
                              } else {
                                Navigator.pushReplacementNamed(
                                    context, '/storyscreen');
                                animationTimer!.cancel();
                                restartTheGame();
                              }
                            },
                            height: 50,
                            textColor: SEColors().white,
                            buttonColor: SEColors().lblue,
                            borderColor: SEColors().blue,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: AnyButton(
                            text: 'CONTINUE',
                            onTapAction: () async {
                              if (await SharedPrefsService().dataExists) {
                                animationTimer!.cancel();
                                Navigator.pushReplacementNamed(
                                    context, '/gamescreen');
                                animationTimer!.cancel();
                                selectedChars[0] = await SharedPrefsService()
                                    .getCharFromLocal(0);
                                selectedChars[1] = await SharedPrefsService()
                                    .getCharFromLocal(1);
                                selectedChars[2] = await SharedPrefsService()
                                    .getCharFromLocal(2);
                                currentEvent = await SharedPrefsService()
                                    .getEventFromLocal();
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
                            height: 50,
                            textColor: SEColors().white,
                            buttonColor: SEColors().lred,
                            borderColor: SEColors().red,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: AnyButton(
                            text: 'EXIT',
                            onTapAction: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return PopUpAlertBox(
                                    alertTitle: 'LEAVING?',
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
                                        onTapAction: () {
                                          animationTimer!.cancel();
                                          SystemNavigator.pop(); // EXIT
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
                            buttonColor: SEColors().grey,
                            borderColor: SEColors().dgrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
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
            image: AssetImage('assets/images/shuttlefly_effect_logo.png'),
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
