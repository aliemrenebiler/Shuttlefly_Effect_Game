// DATABASE CLASSES
class Character {
  String id;
  String name;
  String imgName;

  Character({
    required this.id,
    required this.name,
    required this.imgName,
  });
}

class Skill {
  String id;
  String name;
  String desc;

  Skill({
    required this.id,
    required this.name,
    required this.desc,
  });
}

class Galaxy {
  String id; // galaxy database ID
  String? name; // galaxy name

  Galaxy({
    required this.id,
    this.name,
  });
}

class Event {
  String galaxyID; // galaxy database ID
  String id; // event database ID
  String title; // events title
  String desc; // event description

  Event({
    required this.galaxyID,
    required this.id,
    required this.title,
    required this.desc,
  });
}

class Selection {
  String galaxyID;
  String eventID;
  String? id;
  String desc;
  int healthChange;
  int moraleChange;
  int oxygenChange;
  int sourceChange;
  String? nextEventID;

  Selection({
    required this.galaxyID,
    required this.eventID,
    this.id,
    required this.desc,
    required this.healthChange,
    required this.moraleChange,
    required this.oxygenChange,
    required this.sourceChange,
    this.nextEventID,
  });
}

// OTHERS
class Story {
  String title; // skill name
  String desc; // skill description

  Story({
    required this.title,
    required this.desc,
  });
}

class States {
  int health;
  int morale;
  int oxygen;
  int source;

  States({
    required this.health,
    required this.morale,
    required this.oxygen,
    required this.source,
  });
}
