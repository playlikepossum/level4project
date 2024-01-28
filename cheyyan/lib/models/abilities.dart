class Abilities {
  int strength;
  int intelligence;
  int charisma;
  int constitution;

  Abilities({
    required this.strength,
    required this.intelligence,
    required this.charisma,
    required this.constitution,
  });

  factory Abilities.fromJson(Map<String, dynamic> json) {
    return Abilities(
      strength: json['strength'] ?? 10,
      intelligence: json['intelligence'] ?? 10,
      charisma: json['charisma'] ?? 10,
      constitution: json['constitution'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'strength': strength,
      'intelligence': intelligence,
      'charisma': charisma,
      'constitution': constitution,
    };
  }
}
