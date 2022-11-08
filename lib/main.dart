import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import 'database/methods.dart';
import '/screens/homescreen.dart';
import '/screens/choosescreen.dart';
import '/screens/gamescreen.dart';
import '/screens/storyscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
      overlays: [SystemUiOverlay.bottom]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Fredoka-One",
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/homescreen':
            setAnimationTimer();
            return PageTransition(
              child: const HomeScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/storyscreen':
            if (flowAnimationTimer != null) flowAnimationTimer!.cancel();
            return PageTransition(
              child: const StoryScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/choosescreen':
            if (flowAnimationTimer != null) flowAnimationTimer!.cancel();
            return PageTransition(
              child: const ChooseScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/gamescreen':
            setAnimationTimer();
            return PageTransition(
              child: const GameScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          default:
            setAnimationTimer();
            return PageTransition(
              child: const HomeScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
        }
      },
    );
  }
}
