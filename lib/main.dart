import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_transition/page_transition.dart';

import '/screens/homescreen.dart';
import '/screens/choosescreen.dart';
import '/screens/gamescreen.dart';
import '/screens/storyscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
            return PageTransition(
              child: const HomeScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/storyscreen':
            return PageTransition(
              child: const StoryScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/choosescreen':
            return PageTransition(
              child: const ChooseScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/gamescreen':
            return PageTransition(
              child: const GameScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          default:
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
