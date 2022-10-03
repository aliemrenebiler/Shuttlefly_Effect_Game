import 'package:flutter/material.dart';
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
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: EventBox(
                      notifyParent: refresh,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: StateValueBox(
                            text: 'Health',
                            value: 5,
                            textColor: seWhite,
                            boxColor: sePinkyRed,
                            borderColor: seDarkPinkyRed,
                          ),
                        ),
                        Expanded(
                          child: StateValueBox(
                            text: 'Oxygen',
                            value: 100,
                            textColor: seWhite,
                            boxColor: seLightBlue,
                            borderColor: seBlue,
                          ),
                        ),
                        Expanded(
                          child: StateValueBox(
                            text: 'Morale',
                            value: 5,
                            textColor: seWhite,
                            boxColor: sePurple,
                            borderColor: seDarkPurple,
                          ),
                        ),
                        Expanded(
                          child: StateValueBox(
                            text: 'Energy',
                            value: 5,
                            textColor: seWhite,
                            boxColor: seYellow,
                            borderColor: seDarkYellow,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  AnyButton(
                    text: 'PAUSE',
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
                                              await DatabaseService()
                                                  .eraseSavedData();
                                            },
                                            height: 50,
                                            textColor: seWhite,
                                            buttonColor: sePinkyRed,
                                            borderColor: seDarkPinkyRed,
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                height: 50,
                                textColor: seWhite,
                                buttonColor: sePinkyRed,
                                borderColor: seDarkPinkyRed,
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
                  Expanded(
                    child: CharBox(
                      index: 0,
                      notifyParent: refresh,
                    ),
                  ),
                  Expanded(
                    child: CharBox(
                      index: 1,
                      notifyParent: refresh,
                    ),
                  ),
                  Expanded(
                    child: CharBox(
                      index: 2,
                      notifyParent: refresh,
                    ),
                  ),
                  if (eventPageIndex == 0)
                    AnyButton(
                      text: 'SKIP',
                      onTapAction: () async {
                        selection = await DatabaseService().getSelection(10);
                        skipManageStates();
                        eventPageIndex = 1;
                        DatabaseService().saveStates();
                        refresh(); // SET STATE FULL PAGE
                      },
                      height: 50,
                      textColor: seWhite,
                      buttonColor: sePinkyRed,
                      borderColor: seDarkPinkyRed,
                    )
                  else
                    AnyButton(
                      text: 'DONE',
                      onTapAction: () async {
                        var message = checkStates();
                        if (message == '') {
                          eventPageIndex = 0;
                          event = await DatabaseService().getRandomEvent();
                          await DatabaseService().saveEventID();
                          // SET STATE FULL PAGE
                          refresh();
                        } else {
                          await DatabaseService().eraseSavedData();
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
                      textColor: seDarkPinkyRed,
                      buttonColor: seLightGrey,
                      borderColor: seGrey,
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
  final int borderColor;
  const StateValueBox({
    super.key,
    required this.text,
    required this.value,
    this.width,
    this.height,
    required this.textColor,
    required this.boxColor,
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
      padding: const EdgeInsets.all(3),
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
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(3),
              child: Text(
                widget.text,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  color: Color(widget.textColor),
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(3),
            child: Text(
              '${widget.value}',
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: Color(widget.textColor),
                fontSize: 20,
              ),
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
  final Function() notifyParent;

  const CharBox({
    super.key,
    required this.index,
    this.height,
    this.width,
    required this.notifyParent,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (eventPageIndex != 1) {
          selection = await DatabaseService()
              .getSelection(selectedChars[index].skillID!);
          switch (index) {
            case 0:
              manageStates(
                  selectedChars[0], selectedChars[1], selectedChars[2]);
              break;
            case 1:
              manageStates(
                  selectedChars[1], selectedChars[0], selectedChars[2]);
              break;
            case 2:
              manageStates(
                  selectedChars[2], selectedChars[0], selectedChars[1]);
              break;
          }
          eventPageIndex = 1;
          DatabaseService().saveStates();
          notifyParent(); // SET STATE FULL PAGE
        }
      },
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
                      image: NetworkImage(
                        selectedChars[index].imgURL!,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedChars[index].charName!,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(seDarkPinkyRed),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'The ${selectedChars[index].skillName!}',
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: Color(seBlack),
                        fontSize: 18,
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

// --------------- OLDS -----------------
// EVENT BOX
class EventBox extends StatefulWidget {
  final Function() notifyParent;
  const EventBox({super.key, required this.notifyParent});

  @override
  State<EventBox> createState() => _EventBoxState();
}

class _EventBoxState extends State<EventBox> {
  @override
  Widget build(BuildContext context) {
    widget.notifyParent;
    return Container(
      decoration: BoxDecoration(
        color: Color(seWhite),
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
