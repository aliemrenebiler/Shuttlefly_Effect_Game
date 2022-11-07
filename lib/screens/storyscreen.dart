import 'package:flutter/material.dart';
import '../database/variables.dart';
import '../database/theme.dart';

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
        backgroundColor: SEColors().dblue,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/shuttlefly_effect_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: const TopBar(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    child: const Text(
                      storyDesc,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
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

// TOP BAR
class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: SEColors().lblue,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: seBorderWidth,
          color: SEColors().blue,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TopBarButton(
            text: "BACK",
            onTapAction: () {
              Navigator.pushReplacementNamed(context, '/homescreen');
            },
          ),
          const Expanded(
            child: Text(
              storyTitle,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
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
      ),
    );
  }
}

class TopBarButton extends StatelessWidget {
  final String text;
  final VoidCallback onTapAction;
  const TopBarButton({
    super.key,
    required this.text,
    required this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapAction,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(15),
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
