class Abilities {
  int strength;
  int intelligence;
  int charisma;
  int constitution;
  double strprogress;
  double intprogress;
  double chrprogress;
  double conprogress;
  double exp;

  Abilities({
    required this.strength,
    required this.intelligence,
    required this.charisma,
    required this.constitution,
    required this.strprogress,
    required this.intprogress,
    required this.chrprogress,
    required this.conprogress,
    required this.exp,
  });

  factory Abilities.fromJson(Map<String, dynamic> json) {
    return Abilities(
      strength: json['strength'] ?? 10,
      intelligence: json['intelligence'] ?? 10,
      charisma: json['charisma'] ?? 10,
      constitution: json['constitution'] ?? 10,
      strprogress: json['strprogress'] ?? 0.0,
      intprogress: json['intprogress'] ?? 0.0,
      chrprogress: json['chrprogress'] ?? 0.0,
      conprogress: json['conprogress'] ?? 0.0,
      exp: json['exp'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'strength': strength,
      'intelligence': intelligence,
      'charisma': charisma,
      'constitution': constitution,
      'strprogress': strprogress,
      'intprogress': intprogress,
      'chrprogress': chrprogress,
      'conprogress': conprogress,
      'exp': exp,
    };
  }
}
