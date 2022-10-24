import 'package:sqflite/sqflite.dart';

import 'classes.dart';

const int defaultStateValue = 50;
const int maxtStateValue = 100;
const int minStateValue = 0;

const String storyTitle = 'THE BEGINNING OF THE JOURNEY';
const String storyDesc =
    'Years from now, Earth is in an uninhabitable state. In order to establish a new habitat, 15 astronauts who are experts in their fields were sent to a very distant planet.\n\nHowever, the engineer who took care of the navigation system, poured his cappuccino into the navigation device, minutes before takeoff. But he could not tell anyone because he was embarrassed. After leaving communication area of the solar system, it was noticed by the astronauts that the navigation system was broken. They were on an unknown journey through space.\n\nThere should be 3 captain who can handle this chaotic event...';

Database? database;
int totalCharAmount = 0;
int totalEventAmount = 0;
int totalSkillAmount = 0;

List<Character?> selectedChars = [null, null, null];
List<Skill?> selectedSkills = [null, null, null];

bool eventIsWaiting = true;

Event? currentEvent;
Selection? currentSelection;
States currentStates = States(
  health: defaultStateValue,
  oxygen: defaultStateValue,
  energy: defaultStateValue,
  morale: defaultStateValue,
);
