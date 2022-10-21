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

class Event {
  String id; // event database ID
  String title; // events title
  String desc; // event description

  Event({
    required this.id,
    required this.title,
    required this.desc,
  });
}

class Selection {
  String eventID;
  String? skillID;
  String desc;
  int healthChange;
  int oxygenChange;
  int energyChange;
  int moraleChange;
  String? nextEventID;

  Selection({
    required this.eventID,
    this.skillID,
    required this.desc,
    required this.healthChange,
    required this.oxygenChange,
    required this.energyChange,
    required this.moraleChange,
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
  int oxygen;
  int energy;
  int morale;

  States({
    required this.health,
    required this.oxygen,
    required this.energy,
    required this.morale,
  });
}
