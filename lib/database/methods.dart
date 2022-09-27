import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'classes.dart';
import 'variables.dart';

class DatabaseService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // GET FROM FIREBASE
  Future<Character> getOnlyChar(int id) async {
    var char = await db.collection('characters').doc(id.toString()).get();

    return Character(
      charID: int.parse(char.id),
      charName: char.get('name'),
      imgURL: char.get('imgURL'),
    );
  }

  Future<Character> getOnlySkill(int id) async {
    var skills = await db.collection('skills').doc(id.toString()).get();

    return Character(
      skillID: int.parse(skills.id),
      skillName: skills.get('title'),
      skillDesc: skills.get('desc'),
    );
  }

  Future<Character> getFullChar(int id, int skillId) async {
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
      chosenH: evt.get('chosenH'),
      chosenO: evt.get('chosenO'),
      chosenP: evt.get('chosenP'),
      chosenE: evt.get('chosenE'),
      otherH: evt.get('otherH'),
      otherO: evt.get('otherO'),
      otherP: evt.get('otherP'),
      otherE: evt.get('otherE'),
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
    var select = await db
        .collection('events')
        .doc(event.eventID.toString())
        .collection('selections')
        .doc(id.toString())
        .get();

    return Selection(
      selID: int.parse(select.id),
      success: select.get('success'),
      desc: select.get('desc'),
    );
  }

  // SAVE TO LOCAL
  Future saveCharacters() async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('dataExists', true);

    _prefs.setInt('char1_charID', selectedChars[0].charID!);
    _prefs.setInt('char1_skillID', selectedChars[0].skillID!);
    _prefs.setInt('char1_H', selectedChars[0].health!);
    _prefs.setInt('char1_O', selectedChars[0].oxygen!);
    _prefs.setInt('char1_P', selectedChars[0].psycho!);
    _prefs.setInt('char1_E', selectedChars[0].energy!);

    _prefs.setInt('char2_charID', selectedChars[1].charID!);
    _prefs.setInt('char2_skillID', selectedChars[1].skillID!);
    _prefs.setInt('char2_H', selectedChars[1].health!);
    _prefs.setInt('char2_O', selectedChars[1].oxygen!);
    _prefs.setInt('char2_P', selectedChars[1].psycho!);
    _prefs.setInt('char2_E', selectedChars[1].energy!);

    _prefs.setInt('char3_charID', selectedChars[2].charID!);
    _prefs.setInt('char3_skillID', selectedChars[2].skillID!);
    _prefs.setInt('char3_H', selectedChars[2].health!);
    _prefs.setInt('char3_O', selectedChars[2].oxygen!);
    _prefs.setInt('char3_P', selectedChars[2].psycho!);
    _prefs.setInt('char3_E', selectedChars[2].energy!);
  }

  Future saveStates() async {
    final _prefs = await SharedPreferences.getInstance();

    _prefs.setInt('char1_H', selectedChars[0].health!);
    _prefs.setInt('char1_O', selectedChars[0].oxygen!);
    _prefs.setInt('char1_P', selectedChars[0].psycho!);
    _prefs.setInt('char1_E', selectedChars[0].energy!);

    _prefs.setInt('char2_H', selectedChars[1].health!);
    _prefs.setInt('char2_O', selectedChars[1].oxygen!);
    _prefs.setInt('char2_P', selectedChars[1].psycho!);
    _prefs.setInt('char2_E', selectedChars[1].energy!);

    _prefs.setInt('char3_H', selectedChars[2].health!);
    _prefs.setInt('char3_O', selectedChars[2].oxygen!);
    _prefs.setInt('char3_P', selectedChars[2].psycho!);
    _prefs.setInt('char3_E', selectedChars[2].energy!);
  }

  Future saveEventID() async {
    final _prefs = await SharedPreferences.getInstance();

    _prefs.setInt('eventID', event.eventID!);
  }

  Future<bool> get dataExists async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool('dataExists') ?? false;
  }

  Future<Character> getCharFromLocal(int id) async {
    final _prefs = await SharedPreferences.getInstance();

    var charID = _prefs.getInt('char${id}_charID');
    var skillID = _prefs.getInt('char${id}_skillID');
    var char = await getFullChar(charID!, skillID!);

    char.health = _prefs.getInt('char${id}_H');
    char.oxygen = _prefs.getInt('char${id}_O');
    char.psycho = _prefs.getInt('char${id}_P');
    char.energy = _prefs.getInt('char${id}_E');

    return char;
  }

  Future<int> getEventIDFromLocal() async {
    final _prefs = await SharedPreferences.getInstance();

    return _prefs.getInt('eventID')!;
  }

  Future eraseSavedData() async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
  }
}

void saveSelectedChars() async {
  selectedChars[0].health = defaultStateValue;
  selectedChars[0].oxygen = defaultStateValue;
  selectedChars[0].psycho = defaultStateValue;
  selectedChars[0].energy = defaultStateValue;

  selectedChars[1].health = defaultStateValue;
  selectedChars[1].oxygen = defaultStateValue;
  selectedChars[1].psycho = defaultStateValue;
  selectedChars[1].energy = defaultStateValue;

  selectedChars[2].health = defaultStateValue;
  selectedChars[2].oxygen = defaultStateValue;
  selectedChars[2].psycho = defaultStateValue;
  selectedChars[2].energy = defaultStateValue;

  eventPageIndex = 0;
  await DatabaseService().saveCharacters();
  event = await DatabaseService().getRandomEvent();
  await DatabaseService().saveEventID();
  print("SAVED");
}

void manageStates(Character char1, Character char2, Character char3) {
  if (event.chosenH!) {
    if (selection.success!) {
      char1.health = char1.health! + currentCharState;
      if (char1.health! > maxtStateValue) {
        char1.health = maxtStateValue;
      }
    } else {
      char1.health = char1.health! - currentCharState;
      if (char1.health! < 0) {
        char1.health = 0;
      }
    }
  }

  if (event.chosenO!) {
    if (selection.success!) {
      char1.oxygen = char1.oxygen! + currentCharState;
      if (char1.oxygen! > maxtStateValue) {
        char1.oxygen = maxtStateValue;
      }
    } else {
      char1.oxygen = char1.oxygen! - currentCharState;
      if (char1.oxygen! < 0) {
        char1.oxygen = 0;
      }
    }
  }

  if (event.chosenP!) {
    if (selection.success!) {
      char1.psycho = char1.psycho! + currentCharState;
      if (char1.psycho! > maxtStateValue) {
        char1.psycho = maxtStateValue;
      }
    } else {
      char1.psycho = char1.psycho! - currentCharState;
      if (char1.psycho! < 0) {
        char1.psycho = 0;
      }
    }
  }

  if (event.chosenE!) {
    if (selection.success!) {
      char1.energy = char1.energy! + currentCharState;
      if (char1.energy! > maxtStateValue) {
        char1.energy = maxtStateValue;
      }
    } else {
      char1.energy = char1.energy! - currentCharState;
      if (char1.energy! < 0) {
        char1.energy = 0;
      }
    }
  }

  if (event.otherH!) {
    if (selection.success!) {
      char2.health = char2.health! + otherCharState;
      char3.health = char3.health! + otherCharState;
      if (char2.health! > maxtStateValue) {
        char2.health = maxtStateValue;
      }
      if (char3.health! > maxtStateValue) {
        char3.health = maxtStateValue;
      }
    } else {
      char2.health = char2.health! - otherCharState;
      char3.health = char3.health! - otherCharState;
      if (char2.health! < 0) {
        char2.health = 0;
      }
      if (char3.health! < 0) {
        char3.health = 0;
      }
    }
  }

  if (event.otherO!) {
    if (selection.success!) {
      char2.oxygen = char2.oxygen! + otherCharState;
      char3.oxygen = char3.oxygen! + otherCharState;
      if (char2.oxygen! > maxtStateValue) {
        char2.oxygen = maxtStateValue;
      }
      if (char3.oxygen! > maxtStateValue) {
        char3.oxygen = maxtStateValue;
      }
    } else {
      char2.oxygen = char2.oxygen! - otherCharState;
      char3.oxygen = char3.oxygen! - otherCharState;
      if (char2.oxygen! < 0) {
        char2.oxygen = 0;
      }
      if (char3.oxygen! < 0) {
        char3.oxygen = 0;
      }
    }
  }

  if (event.otherP!) {
    if (selection.success!) {
      char2.psycho = char2.psycho! + otherCharState;
      char3.psycho = char3.psycho! + otherCharState;
      if (char2.psycho! > maxtStateValue) {
        char2.psycho = maxtStateValue;
      }
      if (char3.psycho! > maxtStateValue) {
        char3.psycho = maxtStateValue;
      }
    } else {
      char2.psycho = char2.psycho! - otherCharState;
      char3.psycho = char3.psycho! - otherCharState;
      if (char2.psycho! < 0) {
        char2.psycho = 0;
      }
      if (char3.psycho! < 0) {
        char3.psycho = 0;
      }
    }
  }

  if (event.otherE!) {
    if (selection.success!) {
      char2.energy = char2.energy! + otherCharState;
      char3.energy = char3.energy! + otherCharState;
      if (char2.energy! > maxtStateValue) {
        char2.energy = maxtStateValue;
      }
      if (char3.energy! > maxtStateValue) {
        char3.energy = maxtStateValue;
      }
    } else {
      char2.energy = char2.energy! - otherCharState;
      char3.energy = char3.energy! - otherCharState;
      if (char2.energy! < 0) {
        char2.energy = 0;
      }
      if (char3.energy! < 0) {
        char3.energy = 0;
      }
    }
  }
}

void skipManageStates() {
  if (event.otherH!) {
    if (selection.success!) {
      selectedChars[0].health = selectedChars[0].health! + 5;
      selectedChars[1].health = selectedChars[1].health! + 5;
      selectedChars[2].health = selectedChars[2].health! + 5;
      if (selectedChars[0].health! > 100) {
        selectedChars[0].health = 100;
      }
      if (selectedChars[1].health! > 100) {
        selectedChars[1].health = 100;
      }
      if (selectedChars[2].health! > 100) {
        selectedChars[2].health = 100;
      }
    } else {
      selectedChars[0].health = selectedChars[0].health! - 5;
      selectedChars[1].health = selectedChars[1].health! - 5;
      selectedChars[2].health = selectedChars[2].health! - 5;
      if (selectedChars[0].health! < 0) {
        selectedChars[0].health = 0;
      }
      if (selectedChars[1].health! < 0) {
        selectedChars[1].health = 0;
      }
      if (selectedChars[2].health! < 0) {
        selectedChars[2].health = 0;
      }
    }
  }

  if (event.otherO!) {
    if (selection.success!) {
      selectedChars[0].oxygen = selectedChars[0].oxygen! + 5;
      selectedChars[1].oxygen = selectedChars[1].oxygen! + 5;
      selectedChars[2].oxygen = selectedChars[2].oxygen! + 5;
      if (selectedChars[0].oxygen! > 100) {
        selectedChars[0].oxygen = 100;
      }
      if (selectedChars[1].oxygen! > 100) {
        selectedChars[1].oxygen = 100;
      }
      if (selectedChars[2].oxygen! > 100) {
        selectedChars[2].oxygen = 100;
      }
    } else {
      selectedChars[0].oxygen = selectedChars[0].oxygen! - 5;
      selectedChars[1].oxygen = selectedChars[1].oxygen! - 5;
      selectedChars[2].oxygen = selectedChars[2].oxygen! - 5;
      if (selectedChars[0].oxygen! < 0) {
        selectedChars[0].oxygen = 0;
      }
      if (selectedChars[1].oxygen! < 0) {
        selectedChars[1].oxygen = 0;
      }
      if (selectedChars[2].oxygen! < 0) {
        selectedChars[2].oxygen = 0;
      }
    }
  }

  if (event.otherP!) {
    if (selection.success!) {
      selectedChars[0].psycho = selectedChars[0].psycho! + 5;
      selectedChars[1].psycho = selectedChars[1].psycho! + 5;
      selectedChars[2].psycho = selectedChars[2].psycho! + 5;
      if (selectedChars[0].psycho! > 100) {
        selectedChars[0].psycho = 100;
      }
      if (selectedChars[1].psycho! > 100) {
        selectedChars[1].psycho = 100;
      }
      if (selectedChars[2].psycho! > 100) {
        selectedChars[2].psycho = 100;
      }
    } else {
      selectedChars[0].psycho = selectedChars[0].psycho! - 5;
      selectedChars[1].psycho = selectedChars[1].psycho! - 5;
      selectedChars[2].psycho = selectedChars[2].psycho! - 5;
      if (selectedChars[0].psycho! < 0) {
        selectedChars[0].psycho = 0;
      }
      if (selectedChars[1].psycho! < 0) {
        selectedChars[1].psycho = 0;
      }
      if (selectedChars[2].psycho! < 0) {
        selectedChars[2].psycho = 0;
      }
    }
  }

  if (event.otherE!) {
    if (selection.success!) {
      selectedChars[0].energy = selectedChars[0].energy! + 5;
      selectedChars[1].energy = selectedChars[1].energy! + 5;
      selectedChars[2].energy = selectedChars[2].energy! + 5;
      if (selectedChars[0].energy! > 100) {
        selectedChars[0].energy = 100;
      }
      if (selectedChars[1].energy! > 100) {
        selectedChars[1].energy = 100;
      }
      if (selectedChars[2].energy! > 100) {
        selectedChars[2].energy = 100;
      }
    } else {
      selectedChars[0].energy = selectedChars[0].energy! - 5;
      selectedChars[1].energy = selectedChars[1].energy! - 5;
      selectedChars[2].energy = selectedChars[2].energy! - 5;
      if (selectedChars[0].energy! < 0) {
        selectedChars[0].energy = 0;
      }
      if (selectedChars[1].energy! < 0) {
        selectedChars[1].energy = 0;
      }
      if (selectedChars[2].energy! < 0) {
        selectedChars[2].energy = 0;
      }
    }
  }
}

String checkStates() {
  String message = '';
  int char1Died = 0;
  int char2Died = 0;
  int char3Died = 0;
  if (selectedChars[0].health! <= 0 ||
      selectedChars[0].oxygen! <= 0 ||
      selectedChars[0].psycho! <= 0 ||
      selectedChars[0].energy! <= 0) {
    char1Died = 1;
  }
  if (selectedChars[1].health! <= 0 ||
      selectedChars[1].oxygen! <= 0 ||
      selectedChars[1].psycho! <= 0 ||
      selectedChars[1].energy! <= 0) {
    char2Died = 1;
  }
  if (selectedChars[2].health! <= 0 ||
      selectedChars[2].oxygen! <= 0 ||
      selectedChars[2].psycho! <= 0 ||
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
