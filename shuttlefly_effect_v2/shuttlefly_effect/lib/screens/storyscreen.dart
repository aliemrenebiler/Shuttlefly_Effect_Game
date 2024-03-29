import 'package:flutter/material.dart';

import 'allglobalwidgets.dart';
import '../backend/methods.dart';
import '../backend/theme.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/homescreen');
        return true;
      },
      child: Scaffold(
        body: ContainerWithBG(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: SESizes().spaceScale * 6,
                  right: SESizes().spaceScale * 6,
                  top: SESizes().spaceScale * 6,
                ),
                child: const StoryScreenTopBar(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.all(SESizes().spaceScale * 6),
                    child: Text(
                      storyDesc,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: SEColors().white,
                        fontSize: SESizes().fontSizeMedium,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoryScreenTopBar extends StatelessWidget {
  const StoryScreenTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TopBar(
      widgets: [
        TopBarButton(
          text: "BACK",
          onTapAction: () {
            Navigator.pushReplacementNamed(context, '/homescreen');
          },
        ),
        Expanded(
          child: Text(
            storyTitle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: SEColors().white,
              fontSize: SESizes().fontSizeLarge,
            ),
          ),
        ),
        TopBarButton(
          text: "NEXT",
          onTapAction: () {
            Navigator.pushReplacementNamed(context, '/choosescreen');
          },
        ),
      ],
    );
  }
}
