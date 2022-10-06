class Event {
  int eventID; // event database ID
  String title; // events title
  String desc; // event description

  Event({
    required this.eventID,
    required this.title,
    required this.desc,
  });
}

class Selection {
  int selID; // selection database ID
  String desc; // selection description
  int healthChange;
  int oxygenChange;
  int energyChange;
  int moraleChange;

  Selection({
    required this.selID,
    required this.desc,
    required this.healthChange,
    required this.oxygenChange,
    required this.energyChange,
    required this.moraleChange,
  });
}

class Character {
  int? charID; // character ID
  String? charName; // character name
  String? imgURL; // character's image URL

  int? skillID; // skill ID
  String? skillName; // skill name
  String? skillDesc; // skill description

  Character({
    this.charID,
    this.charName,
    this.imgURL,
    this.skillID,
    this.skillName,
    this.skillDesc,
  });
}

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
