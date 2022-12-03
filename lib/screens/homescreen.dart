import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../backend/methods.dart';
import '../backend/theme.dart';
import 'allglobalwidgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return const ExitMenu();
          },
        );
      },
      child: Scaffold(
        body: ContainerWithBG(
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
                      fontSize: SESizes().fontSizeLarge,
                    ),
                  ),
                );
              } else {
                database = snapshot.data;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(SESizes().spaceScale * 4),
                      width: queryContext!.size.width / 2,
                      child: const AnimatedLogo(),
                    ),
                    Container(
                      padding: EdgeInsets.all(SESizes().spaceScale * 2),
                      width: queryContext!.size.width / 3.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(SESizes().spaceScale * 2),
                            child: const NewGameButton(),
                          ),
                          Container(
                            padding: EdgeInsets.all(SESizes().spaceScale * 2),
                            child: const ContinueButton(),
                          ),
                          Container(
                            padding: EdgeInsets.all(SESizes().spaceScale * 2),
                            child: const ExitButton(),
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
      ),
    );
  }
}

// ANIMATED LOGO
class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: flowAnimationStream,
      builder: (context, snapshot) {
        return AnimatedContainer(
          padding: flowAnimationState
              ? EdgeInsets.only(bottom: SESizes().spaceScale * 10)
              : EdgeInsets.only(top: SESizes().spaceScale * 10),
          duration: const Duration(seconds: 1, milliseconds: 500),
          curve: Curves.easeInOut,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(
                  join("assets", "images", "shuttlefly_effect_logo.png"),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// BUTTONS
class NewGameButton extends StatelessWidget {
  const NewGameButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AnyButton(
      text: 'NEW GAME',
      onTapAction: () async {
        if (await SharedPrefsService().dataExists) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const NewGameMenu();
            },
          );
        } else {
          Navigator.pushReplacementNamed(context, '/storyscreen');
          restartTheGame();
        }
      },
      height: SESizes().defaultButtonHeight,
      textColor: SEColors().white,
      buttonColor: SEColors().lblue,
      borderColor: SEColors().blue,
    );
  }
}

class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AnyButton(
      text: 'CONTINUE',
      onTapAction: () async {
        if (await SharedPrefsService().dataExists) {
          currentGalaxy = await SharedPrefsService().getGalaxyFromLocal();
          currentEvent = await SharedPrefsService().getEventFromLocal();

          selectedChars[0] = await SharedPrefsService().getCharFromLocal(0);
          selectedChars[1] = await SharedPrefsService().getCharFromLocal(1);
          selectedChars[2] = await SharedPrefsService().getCharFromLocal(2);

          selectedProfs[0] = await SharedPrefsService().getProfFromLocal(0);
          selectedProfs[1] = await SharedPrefsService().getProfFromLocal(1);
          selectedProfs[2] = await SharedPrefsService().getProfFromLocal(2);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, '/gamescreen');
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const ContinueAlertBox();
            },
          );
        }
      },
      height: SESizes().defaultButtonHeight,
      textColor: SEColors().white,
      buttonColor: SEColors().lred,
      borderColor: SEColors().red,
    );
  }
}

class ExitButton extends StatelessWidget {
  const ExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AnyButton(
      text: 'EXIT',
      onTapAction: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const ExitMenu();
          },
        );
      },
      height: SESizes().defaultButtonHeight,
      textColor: SEColors().white,
      buttonColor: SEColors().lpurple,
      borderColor: SEColors().purple,
    );
  }
}

// MENUES
class NewGameMenu extends StatelessWidget {
  const NewGameMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopUpAlertBox(
      alertTitle: 'ARE YOU SURE?',
      alertDesc: 'Your previous progress will be deleted.',
      titleColor: SEColors().white,
      textColor: SEColors().grey,
      boxColor: SEColors().black,
      borderColor: SEColors().lblack,
      buttons: [
        AnyButton(
          text: 'NO',
          onTapAction: () {
            Navigator.pop(context);
          },
          height: SESizes().defaultButtonHeight,
          textColor: SEColors().white,
          buttonColor: SEColors().lblue,
          borderColor: SEColors().blue,
        ),
        AnyButton(
          text: 'YES',
          onTapAction: () {
            Navigator.pushReplacementNamed(context, '/storyscreen');
            restartTheGame();
          },
          height: SESizes().defaultButtonHeight,
          textColor: SEColors().white,
          buttonColor: SEColors().lred,
          borderColor: SEColors().red,
        ),
      ],
    );
  }
}

class ContinueAlertBox extends StatelessWidget {
  const ContinueAlertBox({super.key});

  @override
  Widget build(BuildContext context) {
    return PopUpAlertBox(
      alertTitle: 'NO DATA!',
      alertDesc: 'There is no progress saved.\nYou should start a new game.',
      titleColor: SEColors().lyellow2,
      textColor: SEColors().white,
      boxColor: SEColors().black,
      borderColor: SEColors().lblack,
      closeButton: const AlertCloseButton(),
    );
  }
}

class ExitMenu extends StatelessWidget {
  const ExitMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopUpAlertBox(
      alertTitle: 'LEAVING?',
      titleColor: SEColors().white,
      textColor: SEColors().grey,
      boxColor: SEColors().black,
      borderColor: SEColors().lblack,
      buttons: [
        AnyButton(
          text: 'NO',
          onTapAction: () {
            Navigator.pop(context);
          },
          height: SESizes().defaultButtonHeight,
          textColor: SEColors().white,
          buttonColor: SEColors().lblue,
          borderColor: SEColors().blue,
        ),
        AnyButton(
          text: 'YES',
          onTapAction: () {
            SystemNavigator.pop();
          },
          height: SESizes().defaultButtonHeight,
          textColor: SEColors().white,
          buttonColor: SEColors().lred,
          borderColor: SEColors().red,
        ),
      ],
    );
  }
}
