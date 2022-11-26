import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';

import 'classes.dart';

Timer? flowAnimationTimer;
bool flowAnimationState = true;
StreamController<bool> flowAnimationController =
    StreamController<bool>.broadcast();
Stream<bool> flowAnimationStream = flowAnimationController.stream;

const int defaultStateValue = 50;
const int maxtStateValue = 100;
const int minStateValue = 0;

const String storyTitle = 'THE BEGINNING OF THE JOURNEY';
const String storyDesc =
    'Years from now, Earth is in an uninhabitable state. In order to establish a new habitat, 15 astronauts who are experts in their fields were sent to a very distant planet.\n\nHowever, the engineer who took care of the navigation system, poured his cappuccino into the navigation device, minutes before takeoff. But he could not tell anyone because he was embarrassed. After leaving communication area of the solar system, it was noticed by the astronauts that the navigation system was broken. They were on an unknown journey through space.\n\nThere should be 3 captain who can handle this chaotic event...';

Database? database;
int totalCharAmount = 0;
int totalProfAmount = 0;
int totalGalaxyAmount = 0;
List<int> totalEventAmount = [];

List<Character?> selectedChars = [null, null, null];
List<Profession?> selectedProfs = [null, null, null];

bool eventIsWaiting = true;

Galaxy currentGalaxy = Galaxy(id: "0");
Event? currentEvent;
Result? currentResult;
Ending? currentEnding;
States currentStates = States(
  health: defaultStateValue,
  morale: defaultStateValue,
  oxygen: defaultStateValue,
  source: defaultStateValue,
);

class SQLiteServices {
  Future<Database> copyAndOpenDB(String dbName) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dbName);

    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    // Copy from asset
    ByteData data = await rootBundle.load(join("assets", "database", dbName));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes written
    await File(path).writeAsBytes(bytes, flush: true);

    // open the database
    Database db = await openDatabase(path);
    return db;
  }

  getDatabaseLimits() async {
    totalCharAmount = firstIntValue(
        await database!.rawQuery('SELECT COUNT(*) FROM CHARACTERS'))!;
    totalProfAmount = firstIntValue(
        await database!.rawQuery('SELECT COUNT(*) FROM PROFESSIONS'))!;
    totalGalaxyAmount = firstIntValue(
        await database!.rawQuery('SELECT COUNT(*) FROM GALAXIES'))!;
    totalEventAmount = List<int>.generate(totalGalaxyAmount, (index) => 0);
    for (int i = 0; i < totalGalaxyAmount; i++) {
      totalEventAmount[i] = firstIntValue(await database!
          .rawQuery('SELECT COUNT(*) FROM EVENTS WHERE GALAXY_ID = "$i"'))!;
    }
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

  Future<Profession> getProf(String id) async {
    var newProf =
        await database!.rawQuery('SELECT * FROM PROFESSIONS WHERE ID = $id');

    return Profession(
      id: id,
      name: newProf[0]["NAME"] as String,
      desc: newProf[0]["DESC"] as String,
    );
  }

  Future<Event> getEvent(String galaxyID, String id) async {
    var newEvent = await database!.rawQuery(
        'SELECT * FROM EVENTS WHERE GALAXY_ID = $galaxyID AND ID = $id');

    return Event(
      galaxyID: galaxyID,
      id: id,
      title: newEvent[0]["TITLE"] as String,
      desc: newEvent[0]["DESC"] as String,
    );
  }

  getEnding(String id) async {
    var newEnding =
        await database!.rawQuery('SELECT * FROM ENDINGS WHERE ID = $id');

    return Ending(
      id: id,
      healthCondition: (newEnding[0]["HEALTH_CONDITION"] == null)
          ? null
          : newEnding[0]["HEALTH_CONDITION"] as int,
      moraleCondition: (newEnding[0]["MORALE_CONDITION"] == null)
          ? null
          : newEnding[0]["MORALE_CONDITION"] as int,
      oxygenCondition: (newEnding[0]["OXYGEN_CONDITION"] == null)
          ? null
          : newEnding[0]["OXYGEN_CONDITION"] as int,
      sourceCondition: (newEnding[0]["SOURCE_CONDITION"] == null)
          ? null
          : newEnding[0]["SOURCE_CONDITION"] as int,
      title: newEnding[0]["TITLE"] as String,
      desc: newEnding[0]["DESC"] as String,
    );
  }

  getResult(String galaxyID, String eventID, String id, String charName) async {
    var newSelect = await database!.rawQuery(
        'SELECT * FROM RESULTS WHERE GALAXY_ID = $galaxyID AND EVENT_ID = $eventID AND ID = $id');

    if (newSelect.isEmpty) {
      newSelect = await database!.rawQuery(
          "SELECT * FROM RESULTS WHERE GALAXY_ID = $galaxyID AND EVENT_ID = $eventID AND ID IS NULL");
    }

    return Result(
      galaxyID: galaxyID,
      eventID: eventID,
      id: newSelect[0]["ID"] as String,
      desc: "$charName ${newSelect[0]["DESC"] as String}",
      healthChange: newSelect[0]["HEALTH_CHANGE"] as int,
      moraleChange: newSelect[0]["MORALE_CHANGE"] as int,
      oxygenChange: newSelect[0]["OXYGEN_CHANGE"] as int,
      sourceChange: newSelect[0]["SOURCE_CHANGE"] as int,
      endingID: newSelect[0]["ENDING_ID"] as String,
      nextEventID: newSelect[0]["NEXT_EVENT_ID"] as String,
    );
  }
}

class SharedPrefsService {
  Future<bool> get dataExists async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('dataExists') ?? false;
  }

  Future saveCharsAndProfs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('dataExists', true);

    prefs.setString('char0_charID', selectedChars[0]!.id);
    prefs.setString('char0_profID', selectedProfs[0]!.id);

    prefs.setString('char1_charID', selectedChars[1]!.id);
    prefs.setString('char1_profID', selectedProfs[1]!.id);

    prefs.setString('char2_charID', selectedChars[2]!.id);
    prefs.setString('char2_profID', selectedProfs[2]!.id);
  }

  Future saveStates() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('dataExists', true);

    prefs.setInt('currentHealth', currentStates.health);
    prefs.setInt('currentOxygen', currentStates.oxygen);
    prefs.setInt('currentMorale', currentStates.morale);
    prefs.setInt('currentSource', currentStates.source);
  }

  Future saveEventID() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('dataExists', true);

    prefs.setString('currentEventsGalaxyID', currentEvent!.galaxyID);
    prefs.setString('currentEventID', currentEvent!.id);
  }

  Future saveGalaxyID() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('dataExists', true);

    prefs.setString('currentGalaxyID', currentGalaxy.id);
  }

  Future<Character> getCharFromLocal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String charID = prefs.getString('char${id}_charID')!;
    Character char = await SQLiteServices().getChar(charID);
    return char;
  }

  Future<Profession> getProfFromLocal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String profID = prefs.getString('char${id}_profID')!;
    Profession prof = await SQLiteServices().getProf(profID);
    return prof;
  }

  Future<Event> getEventFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    String galaxyID = prefs.getString('currentEventsGalaxyID')!;
    String eventID = prefs.getString('currentEventID')!;
    Event event = await SQLiteServices().getEvent(galaxyID, eventID);
    return event;
  }

  Future<States> getStatesFromLocal() async {
    final prefs = await SharedPreferences.getInstance();

    States states = States(
      health: prefs.getInt('currentHealth')!,
      oxygen: prefs.getInt('currentOxygen')!,
      source: prefs.getInt('currentSource')!,
      morale: prefs.getInt('currentMorale')!,
    );

    return states;
  }

  Future<Galaxy> getGalaxyFromLocal() async {
    final prefs = await SharedPreferences.getInstance();

    Galaxy galaxy = Galaxy(
      id: prefs.getString('currentGalaxyID')!,
    );

    return galaxy;
  }

  Future eraseSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

void setAnimationTimer() async {
  flowAnimationState = true;
  if (flowAnimationTimer != null) flowAnimationTimer!.cancel();
  flowAnimationTimer = Timer.periodic(
    const Duration(seconds: 1, milliseconds: 500),
    (dataTimer) {
      flowAnimationState = !flowAnimationState;
      flowAnimationController.add(flowAnimationState);
    },
  );
}

getRandomEvent(String galaxyID) async {
  Random random = Random();
  int randomGalaxyID = random.nextInt(int.parse(galaxyID) + 1);
  int randomEventID = random.nextInt(totalEventAmount[randomGalaxyID]);
  return await SQLiteServices()
      .getEvent(randomGalaxyID.toString(), randomEventID.toString());
}

void manageStates() {
  if (currentStates.source + currentResult!.sourceChange > 100) {
    currentStates.source = 100;
  } else if (currentStates.source + currentResult!.sourceChange < 0) {
    currentStates.source = 0;
  } else {
    currentStates.source = currentStates.source + currentResult!.sourceChange;
  }

  if (currentStates.health + currentResult!.healthChange > 100) {
    currentStates.health = 100;
  } else if (currentStates.health + currentResult!.healthChange < 0) {
    currentStates.health = 0;
  } else {
    currentStates.health = currentStates.health + currentResult!.healthChange;
  }

  if (currentStates.oxygen + currentResult!.oxygenChange > 100) {
    currentStates.oxygen = 100;
  } else if (currentStates.oxygen + currentResult!.oxygenChange < 0) {
    currentStates.oxygen = 0;
  } else {
    currentStates.oxygen = currentStates.oxygen + currentResult!.oxygenChange;
  }

  if (currentStates.morale + currentResult!.moraleChange > 100) {
    currentStates.morale = 100;
  } else if (currentStates.morale + currentResult!.moraleChange < 0) {
    currentStates.morale = 0;
  } else {
    currentStates.morale = currentStates.morale + currentResult!.moraleChange;
  }
}

checkStates(int? healthCondition, int? moraleCondition, int? oxygenCondition,
    int? sourceCondition) {
  if (currentStates.health == healthCondition ||
      currentStates.morale == moraleCondition ||
      currentStates.oxygen == oxygenCondition ||
      currentStates.source == sourceCondition) {
    SharedPrefsService().eraseSavedData();
    return currentEnding!.desc;
  } else {
    return null;
  }
}

void restartTheGame() async {
  await SharedPrefsService().eraseSavedData();
  await SQLiteServices().getDatabaseLimits();

  currentGalaxy = Galaxy(id: "0");
  currentEvent = null;
  currentResult = null;

  currentStates.source = defaultStateValue;
  currentStates.health = defaultStateValue;
  currentStates.morale = defaultStateValue;
  currentStates.oxygen = defaultStateValue;

  selectedChars = [null, null, null];
  selectedProfs = [null, null, null];

  eventIsWaiting = true;
}
