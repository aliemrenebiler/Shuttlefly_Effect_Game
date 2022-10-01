import 'package:flutter/material.dart';
import '../database/methods.dart';
import '../database/classes.dart';
import '../database/variables.dart';
import '../database/theme.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);
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
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: EventBox(
                notifyParent: refresh,
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: CharStateBox(
                      index: 1,
                      char: selectedChars[0],
                      notifyParent: refresh,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: CharStateBox(
                      index: 2,
                      char: selectedChars[1],
                      notifyParent: refresh,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: CharStateBox(
                      index: 3,
                      char: selectedChars[2],
                      notifyParent: refresh,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: MenuButton(),
                        ),
                        eventPageIndex != 1
                            ? Expanded(
                                flex: 2,
                                child: SkipButton(
                                  notifyParent: refresh,
                                ),
                              )
                            : Expanded(
                                flex: 2,
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
    );
  }
}

// EVENT BOX
class EventBox extends StatefulWidget {
  final Function() notifyParent;
  const EventBox({Key? key, required this.notifyParent}) : super(key: key);

  @override
  State<EventBox> createState() => _EventBoxState();
}

class _EventBoxState extends State<EventBox> {
  @override
  Widget build(BuildContext context) {
    widget.notifyParent;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: seBorderWidth,
          color: Color(seBlue),
        ),
      ),
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          eventPageIndex != 1
              ? Container(
                  margin: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                  child: Text(
                    event.title!,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(seDarkBlue),
                      fontSize: 25,
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                  child: Text(
                    'WHAT HAPPENED?',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(seDarkPinkyRed),
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
                  eventPageIndex != 1 ? event.desc! : selection.desc!,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CHARACTER STATE BOX
class CharStateBox extends StatefulWidget {
  final int index;
  final Character char;
  final Function() notifyParent;

  const CharStateBox({
    Key? key,
    required this.index,
    required this.char,
    required this.notifyParent,
  }) : super(key: key);

  @override
  State<CharStateBox> createState() => _CharStateBoxState();
}

class _CharStateBoxState extends State<CharStateBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (eventPageIndex != 1) {
          selection =
              await DatabaseService().getSelection(widget.char.skillID!);
          switch (widget.index) {
            case 1:
              manageStates(
                  selectedChars[0], selectedChars[1], selectedChars[2]);
              break;
            case 2:
              manageStates(
                  selectedChars[1], selectedChars[0], selectedChars[2]);
              break;
            case 3:
              manageStates(
                  selectedChars[2], selectedChars[0], selectedChars[1]);
              break;
          }
          eventPageIndex = 1;
          DatabaseService().saveStates();
          // SET STATE FULL PAGE
          widget.notifyParent();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(seLightCream),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: seBorderWidth,
            color: Color(seCream),
          ),
        ),
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      widget.char.imgURL!,
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.all(3),
                    child: Text(
                      widget.char.charName! +
                          ' (' +
                          widget.char.skillName! +
                          ')',
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: StateValueBox(
                            text: 'Health',
                            color: sePinkyRed,
                            dColor: seDarkPinkyRed,
                            value: widget.char.health!,
                          ),
                        ),
                        Expanded(
                          child: StateValueBox(
                            text: 'Oxygen',
                            color: seLightBlue,
                            dColor: seBlue,
                            value: widget.char.oxygen!,
                          ),
                        ),
                        Expanded(
                          child: StateValueBox(
                            text: 'Morale',
                            color: sePurple,
                            dColor: seDarkPurple,
                            value: widget.char.psycho!,
                          ),
                        ),
                        Expanded(
                          child: StateValueBox(
                            text: 'Energy',
                            color: seYellow,
                            dColor: seDarkYellow,
                            value: widget.char.energy!,
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
    );
  }
}

// STATE VALUE BOX
class StateValueBox extends StatefulWidget {
  final String text;
  var color;
  var dColor;
  int value;
  StateValueBox({
    Key? key,
    required this.text,
    required this.color,
    required this.dColor,
    required this.value,
  }) : super(key: key);

  @override
  State<StateValueBox> createState() => _StateValueBoxState();
}

class _StateValueBoxState extends State<StateValueBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(widget.color),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: seBorderWidth,
          color: Color(widget.dColor),
        ),
      ),
      margin: const EdgeInsets.all(3),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            '${widget.value}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Text(
            widget.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// NO SAVED DATA BOX
class EndGameBox extends StatelessWidget {
  final String message;
  const EndGameBox({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: seBorderWidth,
          color: Color(seGrey),
        ),
      ),
      child: FittedBox(
        child: Container(
          width: 200,
          margin: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                child: const Text(
                  'THE END',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.all(5),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const MainMenuButton(),
            ],
          ),
        ),
      ),
    );
  }
}

// MENU BOX
class MenuBox extends StatelessWidget {
  const MenuBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: seBorderWidth,
          color: Color(seGrey),
        ),
      ),
      child: FittedBox(
        child: Container(
          width: 200,
          margin: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        'PAUSED',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  const MenuCloseButton(),
                ],
              ),
              const MainMenuButton(),
              const RestartButton(),
            ],
          ),
        ),
      ),
    );
  }
}

// RESTART BOX
class RestartBox extends StatelessWidget {
  const RestartBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(5),
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ARE YOU SURE?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'You will lose all progress.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(sePinkyRed),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const NoButton(),
              const YesButton(),
            ],
          ),
          width: 200,
          margin: const EdgeInsets.all(15),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: seBorderWidth,
          color: Color(seGrey),
        ),
      ),
    );
  }
}

// BUTTONS
class MenuButton extends StatelessWidget {
  const MenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const MenuBox(),
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            );
          },
        );
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(seLightBlue),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: seBorderWidth,
            color: Color(seBlue),
          ),
        ),
        margin: const EdgeInsets.all(5),
        child: const Text(
          'MENU',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}

class SkipButton extends StatelessWidget {
  final Function() notifyParent;
  const SkipButton({Key? key, required this.notifyParent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        selection = await DatabaseService().getSelection(10);
        skipManageStates();
        eventPageIndex = 1;
        DatabaseService().saveStates();
        // SET STATE FULL PAGE
        notifyParent();
      },
      child: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SKIP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Color(sePinkyRed),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: seBorderWidth,
            color: Color(seDarkPinkyRed),
          ),
        ),
        margin: const EdgeInsets.all(5),
      ),
    );
  }
}

class DoneButton extends StatelessWidget {
  final Function() notifyParent;
  const DoneButton({Key? key, required this.notifyParent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var message = checkStates();
        if (message == '') {
          eventPageIndex = 0;
          event = await DatabaseService().getRandomEvent();
          await DatabaseService().saveEventID();
          // SET STATE FULL PAGE
          notifyParent();
        } else {
          await DatabaseService().eraseSavedData();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: EndGameBox(
                  message: message,
                ),
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          );
        }
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          'DONE',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(seDarkPinkyRed),
            fontSize: 30,
          ),
        ),
        height: seButtonHeight,
        decoration: BoxDecoration(
          color: Color(seLightGrey),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: seBorderWidth,
            color: Color(seGrey),
          ),
        ),
        margin: const EdgeInsets.all(5),
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
      },
      child: Container(
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
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
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

class MainMenuButton extends StatelessWidget {
  const MainMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.popUntil(context, (route) => route.isFirst);
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          'MAIN MENU',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        height: seButtonHeight,
        decoration: BoxDecoration(
          color: Color(seLightBlue),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: seBorderWidth,
            color: Color(seBlue),
          ),
        ),
        margin: const EdgeInsets.all(5),
      ),
    );
  }
}

class RestartButton extends StatelessWidget {
  const RestartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const RestartBox(),
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            );
          },
        );
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          'RESTART',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        height: seButtonHeight,
        decoration: BoxDecoration(
          color: Color(sePinkyRed),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: seBorderWidth,
            color: Color(seDarkPinkyRed),
          ),
        ),
        margin: const EdgeInsets.all(5),
      ),
    );
  }
}

class YesButton extends StatelessWidget {
  const YesButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await DatabaseService().eraseSavedData();
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushNamed(context, '/choosescreen');
        // DELETE ALL THE PROGRESS
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          'YES',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        height: seButtonHeight,
        decoration: BoxDecoration(
          color: Color(sePinkyRed),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: seBorderWidth,
            color: Color(seDarkPinkyRed),
          ),
        ),
        margin: const EdgeInsets.all(5),
      ),
    );
  }
}

class NoButton extends StatelessWidget {
  const NoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          'NO',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        height: seButtonHeight,
        decoration: BoxDecoration(
          color: Color(seGrey),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: seBorderWidth,
            color: Color(seDarkGrey),
          ),
        ),
        margin: const EdgeInsets.all(5),
      ),
    );
  }
}
