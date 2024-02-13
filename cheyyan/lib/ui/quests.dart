import 'package:cheyyan/controllers/ability_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Quest {
  final String title;
  final String description;
  final String ability;
  final int requiredLevel;

  Quest({
    required this.title,
    required this.description,
    required this.ability,
    required this.requiredLevel,
  });
}

class QuestProvider {
  final List<Quest> _quests = [
    Quest(
      title: 'Dragon Slayer',
      description: 'Defeat the mighty dragon in the enchanted forest',
      ability: 'strength',
      requiredLevel: 5,
    ),
    Quest(
      title: 'Wizard\'s Tome',
      description:
          'Retrieve the ancient wizard\'s tome from the hidden library',
      ability: 'intelligence',
      requiredLevel: 7,
    ),
    Quest(
      title: 'Puzzle Master',
      description: 'Solve the mystical puzzles guarding the secret chamber',
      ability: 'intelligence',
      requiredLevel: 6,
    ),
    Quest(
      title: 'Charm of the Celestials',
      description: 'Attend a celestial gathering and charm the divine beings',
      ability: 'charisma',
      requiredLevel: 8,
    ),
    Quest(
      title: 'Kindness of the Fae',
      description: 'Spread compliments in the mystical realm of the faeries',
      ability: 'charisma',
      requiredLevel: 7,
    ),
    Quest(
      title: 'Dance of the Spirits',
      description:
          'Participate in a dance class with spirits from the ethereal plane',
      ability: 'charisma',
      requiredLevel: 6,
    ),
    Quest(
      title: 'Feast of the Elves',
      description: 'Host a grand feast for the elves in the enchanted forest',
      ability: 'charisma',
      requiredLevel: 8,
    ),
    Quest(
      title: 'Guild of Shadows',
      description: 'Become a member of the elusive Guild of Shadows',
      ability: 'charisma',
      requiredLevel: 9,
    ),
    Quest(
      title: '''Titan's Strength''',
      description: 'Lift the colossal weights in the realm of the titans',
      ability: 'strength',
      requiredLevel: 6,
    ),
    Quest(
      title: 'Morning Stroll with Griffins',
      description: 'Run for 30 minutes alongside majestic griffins',
      ability: 'constitution',
      requiredLevel: 5,
    ),
    Quest(
      title: 'Aquatic Hydration Challenge',
      description:
          'Drink 8 glasses of enchanted water from the mermaid springs',
      ability: 'constitution',
      requiredLevel: 7,
    ),
    Quest(
      title: 'Herbivore Harmony',
      description:
          'Maintain a vegetarian diet in the magical herbivore kingdom',
      ability: 'constitution',
      requiredLevel: 6,
    ),
    Quest(
      title: 'Tech Detox in the Mystic Forest',
      description:
          'Take a break from screens and connect with nature in the Mystic Forest',
      ability: 'constitution',
      requiredLevel: 8,
    ),
    Quest(
      title: 'Dreamweaver\'s Slumber',
      description:
          'Ensure 8 hours of peaceful sleep in the Dreamweaver\'s realm',
      ability: 'constitution',
      requiredLevel: 9,
    ),
    // Add more quests as needed
  ];

  List<Quest> get quests => _quests;
}

class Quests extends StatefulWidget {
  const Quests({Key? key}) : super(key: key);

  @override
  State<Quests> createState() => _QuestsState();
}

class _QuestsState extends State<Quests> {
  final AbilityController _abilityController = Get.find();
  int strength = 0;
  int intelligence = 0;
  int charisma = 0;
  int constitution = 0;

  final QuestProvider _questProvider = QuestProvider();
  @override
  void initState() {
    super.initState();
    print('init state called');
    _abilityController.getAbilities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quests',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        itemCount: _questProvider.quests.length,
        itemBuilder: (context, index) {
          final quest = _questProvider.quests[index];
          return Card(
            elevation: 3.0,
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Required ${quest.ability[0].toUpperCase()}${quest.ability.substring(1).toLowerCase()} Stat: ${quest.requiredLevel}',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  quest.description,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white70,
                  ),
                ),
              ),
              tileColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              onTap: () {
                // Assuming you have a function to update the user's stats in your database
                // You need to implement this function based on your database logic
                completeQuest(quest);
              },
            ),
          );
        },
      ),
    );
  }

  void completeQuest(Quest quest) {
    _abilityController.getAbilities();
    _abilityController.abilityList
        .map((ability) => {
              strength = ability.strength,
              intelligence = ability.intelligence,
              charisma = ability.intelligence,
              constitution = ability.intelligence,
            })
        .toList();

    print('Strength: $strength');
    print('Intelligence: $intelligence');
    print('Charisma: $charisma');
    print('Constitution: $constitution');
    if (quest.ability == 'strength' && strength >= quest.requiredLevel) {
      _abilityController.levelUP(quest.requiredLevel / 5);
      setState(() {
        _questProvider.quests.remove(quest);
      });
    }
    if (quest.ability == 'intelligence' &&
        intelligence >= quest.requiredLevel) {
      _abilityController.levelUP(quest.requiredLevel / 5);
      setState(() {
        _questProvider.quests.remove(quest);
      });
    }
    if (quest.ability == 'charisma' && charisma >= quest.requiredLevel) {
      _abilityController.levelUP(quest.requiredLevel / 5);
      setState(() {
        _questProvider.quests.remove(quest);
      });
    }
    if (quest.ability == 'constitution' &&
        constitution >= quest.requiredLevel) {
      _abilityController.levelUP(quest.requiredLevel / 5);
      setState(() {
        _questProvider.quests.remove(quest);
      });
    }
    // Assuming you have a function in your database logic to update stats
    // You need to implement this function based on your database logic
    // _abilityController.incrementAbilityName(quest.ability);

    // Update the UI
  }
}
