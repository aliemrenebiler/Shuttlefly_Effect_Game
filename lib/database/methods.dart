import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';

import 'classes.dart';
import 'variables.dart';

class SQLiteServices {
  Future<Database> copyAndOpenDB(String dbName) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dbName);

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "database", dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    }

    // open the database
    Database db = await openDatabase(path);
    return db;
  }

  getDatabaseLimits() async {
    totalCharAmount = firstIntValue(
        await database!.rawQuery('SELECT COUNT(*) FROM CHARACTERS'))!;
    totalSkillAmount =
        firstIntValue(await database!.rawQuery('SELECT COUNT(*) FROM SKILLS'))!;
    totalEventAmount =
        firstIntValue(await database!.rawQuery('SELECT COUNT(*) FROM EVENTS'))!;
  }

  Future<Character> getChar(String id) async {
    var newChar =
        await database!.rawQuery('SELECT * FROM CHARACTERS WHERE ID = $id');

    return Character(
      id: id,
      name: newChar[0]["NAME"] as String,
      imgName: newChar[0]["IMG_NAME"] as String,
    );
  }

  Future<Skill> getSkill(String id) async {
    var newSkill =
        await database!.rawQuery('SELECT * FROM SKILLS WHERE ID = $id');

    return Skill(
      id: id,
      name: newSkill[0]["NAME"] as String,
      desc: newSkill[0]["DESC"] as String,
    );
  }

  Future<Event> getEvent(String id) async {
    var newEvent =
        await database!.rawQuery('SELECT * FROM EVENTS WHERE ID = $id');

    return Event(
      id: id,
      title: newEvent[0]["TITLE"] as String,
      desc: newEvent[0]["DESC"] as String,
    );
  }

  getSelection(String eventID, String skillID, String charName) async {
    var newSelect = await database!.rawQuery(
        'SELECT * FROM SELECTIONS WHERE EVENT_ID = $eventID AND SKILL_ID = $skillID');

    if (newSelect.isEmpty) {
      newSelect = await database!.rawQuery(
          "SELECT * FROM SELECTIONS WHERE EVENT_ID = $eventID AND SKILL_ID IS NULL");
    }

    return Selection(
      eventID: eventID,
      skillID: newSelect[0]["SKILL_ID"] as String,
      desc: "$charName ${newSelect[0]["DESC"] as String}",
      energyChange: newSelect[0]["ENERGY_CHANGE"] as int,
      healthChange: newSelect[0]["HEALTH_CHANGE"] as int,
      moraleChange: newSelect[0]["MORALE_CHANGE"] as int,
      oxygenChange: newSelect[0]["OXYGEN_CHANGE"] as int,
      nextEventID: newSelect[0]["NEXT_EVENT_ID"] as String,
    );
  }
}

class SharedPrefsService {
  Future saveCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('dataExists', true);

    prefs.setString('char0_charID', selectedChars[0]!.id);
    prefs.setString('char0_skillID', selectedSkills[0]!.id);

    prefs.setString('char1_charID', selectedChars[1]!.id);
    prefs.setString('char1_skillID', selectedSkills[1]!.id);

    prefs.setString('char2_charID', selectedChars[2]!.id);
    prefs.setString('char2_skillID', selectedSkills[2]!.id);

    prefs.setInt('currentHealth', currentStates.health);
    prefs.setInt('currentOxygen', currentStates.oxygen);
    prefs.setInt('currentMorale', currentStates.morale);
    prefs.setInt('currentEnergy', currentStates.energy);
  }

  Future saveStates() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setInt('currentHealth', currentStates.health);
    prefs.setInt('currentOxygen', currentStates.oxygen);
    prefs.setInt('currentMorale', currentStates.morale);
    prefs.setInt('currentEnergy', currentStates.energy);
  }

  Future saveEventID() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentEventID', currentEvent!.id);
  }

  Future<bool> get dataExists async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('dataExists') ?? false;
  }

  Future<Character> getCharFromLocal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String charID = prefs.getString('char${id}_charID')!;
    Character char = await SQLiteServices().getChar(charID);
    return char;
  }

  Future<Skill> getSkillFromLocal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String skillID = prefs.getString('char${id}_skillID')!;
    Skill skill = await SQLiteServices().getSkill(skillID);
    return skill;
  }

  Future<Event> getEventFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    String eventID = prefs.getString('currentEventID')!;
    Event event = await SQLiteServices().getEvent(eventID);
    return event;
  }

  Future<States> getStatesFromLocal() async {
    final prefs = await SharedPreferences.getInstance();

    States states = States(
      health: prefs.getInt('currentHealth')!,
      oxygen: prefs.getInt('currentOxygen')!,
      energy: prefs.getInt('currentEnergy')!,
      morale: prefs.getInt('currentMorale')!,
    );

    return states;
  }

  Future eraseSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

getRandomEvent() async {
  Random random = Random();
  int randomNumber = random.nextInt(totalEventAmount);
  return await SQLiteServices().getEvent(randomNumber.toString());
}

void manageStates() {
  if (currentStates.energy + currentSelection!.energyChange > 100) {
    currentStates.energy = 100;
  } else if (currentStates.energy + currentSelection!.energyChange < 0) {
    currentStates.energy = 0;
  } else {
    currentStates.energy =
        currentStates.energy + currentSelection!.energyChange;
  }

  if (currentStates.health + currentSelection!.healthChange > 100) {
    currentStates.health = 100;
  } else if (currentStates.health + currentSelection!.healthChange < 0) {
    currentStates.health = 0;
  } else {
    currentStates.health =
        currentStates.health + currentSelection!.healthChange;
  }

  if (currentStates.oxygen + currentSelection!.oxygenChange > 100) {
    currentStates.oxygen = 100;
  } else if (currentStates.oxygen + currentSelection!.oxygenChange < 0) {
    currentStates.oxygen = 0;
  } else {
    currentStates.oxygen =
        currentStates.oxygen + currentSelection!.oxygenChange;
  }

  if (currentStates.morale + currentSelection!.moraleChange > 100) {
    currentStates.morale = 100;
  } else if (currentStates.morale + currentSelection!.moraleChange < 0) {
    currentStates.morale = 0;
  } else {
    currentStates.morale =
        currentStates.morale + currentSelection!.moraleChange;
  }
}

checkStates() {
  if (currentStates.health <= 0) {
    SharedPrefsService().eraseSavedData();
    return 'The crew bled to death.';
  } else if (currentStates.oxygen <= 0) {
    SharedPrefsService().eraseSavedData();
    return 'The crew is out of oxygen.';
  } else if (currentStates.morale <= 0) {
    SharedPrefsService().eraseSavedData();
    return 'The crew got crazy.';
  } else if (currentStates.energy <= 0) {
    SharedPrefsService().eraseSavedData();
    return "The crew can't make any move.";
  } else {
    return null;
  }
}

void restartTheGame() async {
  currentStates.energy = defaultStateValue;
  currentStates.health = defaultStateValue;
  currentStates.morale = defaultStateValue;
  currentStates.oxygen = defaultStateValue;
  currentSelection = null;
  eventIsWaiting = true;
  await SharedPrefsService().eraseSavedData();
  await SQLiteServices().getDatabaseLimits();
}
