import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../backend/methods.dart';
import '../backend/theme.dart';

// CONTAINER WITH BACKGROUND
class ContainerWithBG extends StatelessWidget {
  final Widget? child;
  const ContainerWithBG({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    queryContext = MediaQuery.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            join("assets", "images", "shuttlefly_effect_bg.png"),
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}

// TOP BAR
class TopBar extends StatelessWidget {
  final List<Widget>? widgets;
  const TopBar({
    super.key,
    this.widgets,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SESizes().sizeScale * 50,
      decoration: BoxDecoration(
        color: SEColors().lblue,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: seBorderWidth,
          color: SEColors().blue,
        ),
      ),
      child: (widgets != null || widgets!.isNotEmpty)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int i = 0; i < widgets!.length; i++) widgets![i],
              ],
            )
          : null,
    );
  }
}

class TopBarButton extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final VoidCallback onTapAction;
  const TopBarButton({
    super.key,
    required this.text,
    this.width,
    this.height,
    required this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapAction,
      child: Container(
        height: (height != null) ? height : null,
        width: (width != null) ? width : null,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: SESizes().spaceScale * 6),
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: SEColors().white,
            fontSize: SESizes().fontSizeMedium,
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
  final List<Widget>? buttons;
  final Color titleColor;
  final Color textColor;
  final Color boxColor;
  final Color borderColor;
  final Widget? closeButton;
  const PopUpAlertBox({
    super.key,
    required this.alertTitle,
    this.alertDesc,
    this.buttons,
    required this.titleColor,
    required this.textColor,
    required this.boxColor,
    required this.borderColor,
    this.closeButton,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Container(
        width: queryContext!.size.width / 2,
        padding: EdgeInsets.all(SESizes().spaceScale * 4),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: seBorderWidth,
            color: borderColor,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: closeButton != null
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(SESizes().spaceScale * 2),
                    alignment: closeButton != null
                        ? Alignment.bottomLeft
                        : Alignment.bottomCenter,
                    child: Text(
                      alertTitle,
                      textAlign: closeButton != null
                          ? TextAlign.left
                          : TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: SESizes().fontSizeLarge,
                      ),
                    ),
                  ),
                ),
                if (closeButton != null)
                  Container(
                    padding: EdgeInsets.all(SESizes().spaceScale * 2),
                    child: closeButton,
                  ),
              ],
            ),
            if (alertDesc != null)
              Container(
                alignment: closeButton != null
                    ? Alignment.centerLeft
                    : Alignment.center,
                padding: EdgeInsets.all(SESizes().spaceScale * 2),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    alertDesc!,
                    textAlign:
                        closeButton != null ? TextAlign.left : TextAlign.center,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: textColor,
                      fontSize: SESizes().fontSizeMedium,
                    ),
                  ),
                ),
              ),
            if (buttons != null)
              for (int i = 0; i < buttons!.length; i++)
                Container(
                  padding: EdgeInsets.all(SESizes().spaceScale * 2),
                  child: buttons![i],
                ),
          ],
        ),
      ),
    );
  }
}

class AlertCloseButton extends StatelessWidget {
  const AlertCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AnyButton(
      text: 'X',
      onTapAction: () {
        Navigator.pop(context);
      },
      height: SESizes().sizeScale * 45,
      width: SESizes().sizeScale * 45,
      textColor: SEColors().dgrey,
      buttonColor: SEColors().lblack,
      borderColor: SEColors().dgrey2,
    );
  }
}

// SELECTION BOXES
class CharSelection extends StatelessWidget {
  final int index;
  final bool isEmpty;
  final bool isDraggable;
  final double? height;
  final double? width;
  const CharSelection({
    super.key,
    required this.index,
    required this.isEmpty,
    required this.isDraggable,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (height != null) ? height : null,
      width: (width != null) ? width : null,
      padding: EdgeInsets.all(SESizes().spaceScale),
      decoration: BoxDecoration(
        color: SEColors().red,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: seBorderWidth,
          color: SEColors().lred,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(SESizes().spaceScale),
            child: (!isDraggable)
                ? SizedBox(
                    height: SESizes().sizeScale * 60,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: SEColors().red,
                          border: Border.all(
                            width: seBorderWidth,
                            color: SEColors().dred,
                          ),
                          image: (isEmpty)
                              ? null
                              : DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    join("assets", "images",
                                        selectedChars[index]!.imgName),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  )
                : Draggable<int>(
                    data: index,
                    feedback: SizedBox(
                      height: SESizes().sizeScale * 60,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: SEColors().dred,
                            border: Border.all(
                              width: seBorderWidth,
                              color: SEColors().dred,
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                join("assets", "images",
                                    selectedChars[index]!.imgName),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    childWhenDragging: SizedBox(
                      height: SESizes().sizeScale * 60,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: SEColors().dred,
                            border: Border.all(
                              width: seBorderWidth,
                              color: SEColors().dred,
                            ),
                          ),
                        ),
                      ),
                    ),
                    child: SizedBox(
                      height: SESizes().sizeScale * 60,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: SEColors().red,
                            border: Border.all(
                              width: seBorderWidth,
                              color: SEColors().dred,
                            ),
                            image: (isEmpty)
                                ? null
                                : DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      join("assets", "images",
                                          selectedChars[index]!.imgName),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          Container(
            padding: EdgeInsets.all(SESizes().spaceScale),
            alignment: Alignment.center,
            child: Text(
              (isEmpty) ? "..." : selectedChars[index]!.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: SEColors().white,
                fontSize: SESizes().fontSizeSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfSelection extends StatelessWidget {
  final int index;
  final bool isEmpty;
  const ProfSelection({
    super.key,
    required this.index,
    required this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isEmpty) {
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
        }
      },
      child: Container(
        padding: EdgeInsets.all(SESizes().spaceScale),
        decoration: BoxDecoration(
          color: SEColors().blue,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: seBorderWidth,
            color: SEColors().lblue,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          (isEmpty) ? "..." : selectedProfs[index]!.name,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: SEColors().white,
            fontSize: SESizes().fontSizeSmall,
          ),
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
            fontSize: SESizes().fontSizeMedium,
          ),
        ),
      ),
    );
  }
}
