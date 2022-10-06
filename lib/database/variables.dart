import 'classes.dart';

int eventPageIndex = 0;

int characterTypesAmount = 0;
int eventTypesAmount = 0;
int skillTypesAmount = 0;

Event currentEvent = Event();
Selection? currentSelection;

List<Character> selectedChars = [
  Character(),
  Character(),
  Character(),
];

States currentStates = States(
  health: defaultStateValue,
  oxygen: defaultStateValue,
  energy: defaultStateValue,
  morale: defaultStateValue,
);

var story = Story(
    title: 'THE BEGINNING OF THE JOURNEY',
    desc:
        'Years from now, Earth is in an uninhabitable state. In order to establish a new habitat, 15 astronauts who are experts in their fields were sent to a very distant planet.\n\nHowever, the engineer who took care of the navigation system, poured his cappuccino into the navigation device, minutes before takeoff. But he could not tell anyone because he was embarrassed. After leaving communication area of the solar system, it was noticed by the astronauts that the navigation system was broken. They were on an unknown journey through space.\n\nThere should be 3 captain who can handle this chaotic event...');

int defaultStateValue = 50;
int maxtStateValue = 100;
int minStateValue = 0;
