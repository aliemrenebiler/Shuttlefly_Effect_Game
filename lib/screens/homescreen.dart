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
                      width: MediaQuery.of(context).size.width / 2,
                      child: const AnimatedLogo(),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: const NewGameButton(),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: const ContinueButton(),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
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
              ? const EdgeInsets.only(bottom: 30)
              : const EdgeInsets.only(top: 30),
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
              return PopUpAlertBox(
                alertTitle: 'ARE YOU SURE?',
                alertDesc: 'Your previous progress will be deleted.',
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
                      Navigator.pushReplacementNamed(context, '/storyscreen');
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
          Navigator.pushReplacementNamed(context, '/storyscreen');
          restartTheGame();
        }
      },
      height: 50,
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
      height: 50,
      textColor: SEColors().white,
      buttonColor: SEColors().grey,
      borderColor: SEColors().dgrey,
    );
  }
}

// EXIT MENU
class ExitMenu extends StatelessWidget {
  const ExitMenu({super.key});

  @override
  Widget build(BuildContext context) {
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
            SystemNavigator.pop();
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
