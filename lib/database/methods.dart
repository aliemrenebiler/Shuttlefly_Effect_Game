import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'classes.dart';
import 'variables.dart';

class DatabaseService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  getDatabaseLimits() async {
    var characters =
        await db.collection('characters').doc('characterCount').get();
    characterTypesAmount = characters.get('count');

    var events = await db.collection('events').doc('eventCount').get();
    eventTypesAmount = events.get('count');

    var skills = await db.collection('skills').doc('skillCount').get();
    skillTypesAmount = skills.get('count');
  }

  Future<Character> getCharInfo(Character char, int id) async {
    var newChar = await db.collection('characters').doc(id.toString()).get();

    char.charID = int.parse(newChar.id);
    char.charName = newChar.get('name');
    char.imgURL = newChar.get('imgURL');

    return char;
  }

  Future<Character> getSkillInfo(Character char, int id) async {
    var newSkill = await db.collection('skills').doc(id.toString()).get();

    char.skillID = int.parse(newSkill.id);
    char.skillName = newSkill.get('title');
    char.skillDesc = newSkill.get('desc');

    return char;
  }

  Future<Event> getEvent(int id) async {
    var evt = await db.collection('events').doc(id.toString()).get();

    return Event(
      eventID: int.parse(evt.id),
      title: evt.get('title'),
      desc: evt.get('desc'),
    );
  }

  Future<Event> getRandomEvent() async {
    Random random = Random();
    int randomNumber = random.nextInt(eventTypesAmount);
    return await DatabaseService().getEvent(randomNumber);
  }

  getSelection(int id, String? charName) async {
    var selection = await db
        .collection('events')
        .doc(currentEvent.eventID.toString())
        .collection('selections')
        .doc(id.toString())
        .get();
    if (selection.data() == null) {
      return null;
    } else {
      return Selection(
        selID: int.parse(selection.id),
        desc: (charName != null)
            ? "$charName ${selection.get('desc')}"
            : selection.get('desc'),
        healthChange: selection.get('healthChange'),
        oxygenChange: selection.get('oxygenChange'),
        energyChange: selection.get('energyChange'),
        moraleChange: selection.get('moraleChange'),
      );
    }
  }
}

class SharedPrefsService {
  Future saveCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('dataExists', true);

    prefs.setInt('char0_charID', selectedChars[0].charID!);
    prefs.setInt('char0_skillID', selectedChars[0].skillID!);

    prefs.setInt('char1_charID', selectedChars[1].charID!);
    prefs.setInt('char1_skillID', selectedChars[1].skillID!);

    prefs.setInt('char2_charID', selectedChars[2].charID!);
    prefs.setInt('char2_skillID', selectedChars[2].skillID!);

    prefs.setInt('currentHealth', currentStates.health!);
    prefs.setInt('currentOxygen', currentStates.oxygen!);
    prefs.setInt('currentPsycho', currentStates.morale!);
    prefs.setInt('currentEnergy', currentStates.energy!);
  }

  Future saveStates() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setInt('currentHealth', currentStates.health!);
    prefs.setInt('currentOxygen', currentStates.oxygen!);
    prefs.setInt('currentPsycho', currentStates.morale!);
    prefs.setInt('currentEnergy', currentStates.energy!);
  }

  Future saveEventID() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setInt('currentEventID', currentEvent.eventID!);
  }

  Future<bool> get dataExists async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('dataExists') ?? false;
  }

  Future<Character> getCharFromLocal(int id) async {
    final prefs = await SharedPreferences.getInstance();

    var charID = prefs.getInt('char${id}_charID');
    var skillID = prefs.getInt('char${id}_skillID');
    Character char = Character();
    char = await DatabaseService().getCharInfo(char, charID!);
    char = await DatabaseService().getSkillInfo(char, skillID!);

    return char;
  }

  Future<States> getStatesFromLocal() async {
    final prefs = await SharedPreferences.getInstance();

    States states = States();
    states.health = prefs.getInt('currentHealth');
    states.oxygen = prefs.getInt('currentOxygen');
    states.morale = prefs.getInt('currentPsycho');
    states.energy = prefs.getInt('currentEnergy');

    return states;
  }

  Future<int> getEventIDFromLocal() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt('currentEventID')!;
  }

  Future eraseSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

void saveSelectedChars() async {
  currentStates.health = defaultStateValue;
  currentStates.oxygen = defaultStateValue;
  currentStates.morale = defaultStateValue;
  currentStates.energy = defaultStateValue;

  eventPageIndex = 0;
  await SharedPrefsService().saveCharacters();
  currentEvent = await DatabaseService().getRandomEvent();
  await SharedPrefsService().saveEventID();
}

void manageStates() {
  if (currentStates.energy! + currentSelection!.energyChange > 100) {
    currentStates.energy = 100;
  } else {
    currentStates.energy =
        currentStates.energy! + currentSelection!.energyChange;
  }

  if (currentStates.health! + currentSelection!.healthChange > 100) {
    currentStates.health = 100;
  } else {
    currentStates.health =
        currentStates.health! + currentSelection!.healthChange;
  }

  if (currentStates.oxygen! + currentSelection!.oxygenChange > 100) {
    currentStates.oxygen = 100;
  } else {
    currentStates.oxygen =
        currentStates.oxygen! + currentSelection!.oxygenChange;
  }

  if (currentStates.morale! + currentSelection!.moraleChange > 100) {
    currentStates.morale = 100;
  } else {
    currentStates.morale =
        currentStates.morale! + currentSelection!.moraleChange;
  }
}

checkStates() {
  if (currentStates.health! <= 0) {
    return 'The crew bled to death.';
  } else if (currentStates.oxygen! <= 0) {
    return 'The crew is out of oxygen.';
  } else if (currentStates.morale! <= 0) {
    return 'The crew got crazy.';
  } else if (currentStates.energy! <= 0) {
    return "The crew can't make any move.";
  } else {
    return null;
  }
}
