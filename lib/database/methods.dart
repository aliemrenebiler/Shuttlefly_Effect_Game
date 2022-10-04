import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'classes.dart';
import 'variables.dart';

class DatabaseService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // GET FROM FIREBASE
  Future<Character> getCharInfo(int id) async {
    var char = await db.collection('characters').doc(id.toString()).get();

    return Character(
      charID: int.parse(char.id),
      charName: char.get('name'),
      imgURL: char.get('imgURL'),
    );
  }

  Future<Character> getSkillInfo(int id) async {
    var skills = await db.collection('skills').doc(id.toString()).get();

    return Character(
      skillID: int.parse(skills.id),
      skillName: skills.get('title'),
      skillDesc: skills.get('desc'),
    );
  }

// BU FONKSİYONU SİLMEYE ÇALIŞ
  Future<Character> getCharWithSkill(int id, int skillId) async {
    var char = await db.collection('characters').doc(id.toString()).get();
    var skills = await db.collection('skills').doc(skillId.toString()).get();

    return Character(
      charID: int.parse(char.id),
      charName: char.get('name'),
      imgURL: char.get('imgURL'),
      skillID: int.parse(skills.id),
      skillName: skills.get('title'),
      skillDesc: skills.get('desc'),
    );
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
    var event = await db.collection('events').doc('eventCount').get();
    int eventCount = event.get('count');

    Random random = Random();
    int randomNumber = random.nextInt(eventCount);

    return DatabaseService().getEvent(randomNumber);
  }

  Future<Selection> getSelection(int id) async {
    var selection = await db
        .collection('events')
        .doc(currentEvent.eventID.toString())
        .collection('selections')
        .doc(id.toString())
        .get();

    return Selection(
      selID: int.parse(selection.id),
      desc: selection.get('desc'),
      healthChange: selection.get('healthChange'),
      oxygenChange: selection.get('oxygenChange'),
      energyChange: selection.get('energyChange'),
      moraleChange: selection.get('moraleChange'),
    );
  }
}

class SharedPrefsService {
  Future saveCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('dataExists', true);

    prefs.setInt('char1_charID', selectedChars[0].charID!);
    prefs.setInt('char1_skillID', selectedChars[0].skillID!);

    prefs.setInt('char2_charID', selectedChars[1].charID!);
    prefs.setInt('char2_skillID', selectedChars[1].skillID!);

    prefs.setInt('char3_charID', selectedChars[2].charID!);
    prefs.setInt('char3_skillID', selectedChars[2].skillID!);

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
    var char = await DatabaseService().getCharWithSkill(charID!, skillID!);

    currentStates.health = prefs.getInt('currentHealth');
    currentStates.oxygen = prefs.getInt('currentOxygen');
    currentStates.morale = prefs.getInt('currentPsycho');
    currentStates.energy = prefs.getInt('currentEnergy');

    return char;
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

void manageStates(Character char) {
  currentStates.energy = currentStates.energy! + currentSelection!.energyChange;
  currentStates.health = currentStates.health! + currentSelection!.healthChange;
  currentStates.oxygen = currentStates.oxygen! + currentSelection!.oxygenChange;
  currentStates.morale = currentStates.morale! + currentSelection!.moraleChange;
}

void skipManageStates() {
  currentStates.energy = currentStates.energy! + currentSelection!.energyChange;
  currentStates.health = currentStates.health! + currentSelection!.healthChange;
  currentStates.oxygen = currentStates.oxygen! + currentSelection!.oxygenChange;
  currentStates.morale = currentStates.morale! + currentSelection!.moraleChange;
}

String checkStates() {
  String message = '';
  int char1Died = 0;
  int char2Died = 0;
  int char3Died = 0;
  if (selectedChars[0].health! <= 0 ||
      selectedChars[0].oxygen! <= 0 ||
      selectedChars[0].morale! <= 0 ||
      selectedChars[0].energy! <= 0) {
    char1Died = 1;
  }
  if (selectedChars[1].health! <= 0 ||
      selectedChars[1].oxygen! <= 0 ||
      selectedChars[1].morale! <= 0 ||
      selectedChars[1].energy! <= 0) {
    char2Died = 1;
  }
  if (selectedChars[2].health! <= 0 ||
      selectedChars[2].oxygen! <= 0 ||
      selectedChars[2].morale! <= 0 ||
      selectedChars[2].energy! <= 0) {
    char3Died = 1;
  }

  if (char1Died == 1) {
    message = message + selectedChars[0].charName!;
  }

  if (char2Died == 1) {
    if (char1Died == 1) {
      message = message + ', ';
    }
    message = message + selectedChars[1].charName!;
  }

  if (char3Died == 1) {
    if (char1Died == 1 || char2Died == 1) {
      message = message + ', ';
    }
    message = message + selectedChars[2].charName!;
  }

  if (message == '') {
    return '';
  } else {
    return message + ' eliminated.';
  }
}
