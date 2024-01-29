import 'package:cheyyan/controllers/ability_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Quest {
  final String title;
  final String description;
  final String ability;

  Quest({
    required this.title,
    required this.description,
    required this.ability,
  });
}

class QuestProvider {
  final List<Quest> _quests = [
    Quest(
        title: 'Run a Marathon',
        description: 'Run 42 kilometers',
        ability: 'strength'),
    Quest(
        title: 'Read a Book',
        description: 'Read a book of your choice',
        ability: 'intelligence'),
    Quest(
        title: 'Solve Puzzles',
        description: 'Complete a set of challenging puzzles',
        ability: 'intelligence'),
    Quest(
        title: 'Networking Mixer',
        description: 'Attend a networking event and make new connections',
        ability: 'charisma'),
    Quest(
        title: 'Compliment Challenge',
        description: 'Compliment at least three people today',
        ability: 'charisma'),
    Quest(
        title: 'Social Dance Class',
        description: 'Take a social dance class to improve social skills',
        ability: 'charisma'),
    Quest(
        title: 'Host a Gathering',
        description: 'Host a small gathering or dinner party',
        ability: 'charisma'),
    Quest(
        title: 'Join a Social Club',
        description: 'Become a member of a social or community club',
        ability: 'charisma'),
    Quest(
        title: 'Lift Weights',
        description: 'Lift weights at the gym',
        ability: 'strength'),
    Quest(
        title: 'Morning Jog',
        description: 'Run for 30 minutes in the morning',
        ability: 'constitution'),
    Quest(
        title: 'Hydration Challenge',
        description: 'Drink 8 glasses of water every day',
        ability: 'constitution'),
    Quest(
        title: 'Vegetarian Day',
        description: 'Have a vegetarian diet for a day',
        ability: 'constitution'),
    Quest(
        title: 'Digital Detox',
        description: 'Take a break from screens for a day',
        ability: 'constitution'),
    Quest(
        title: 'Quality Sleep',
        description: 'Ensure 8 hours of quality sleep each night',
        ability: 'constitution'),

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
  final AbilityController _abilityController = Get.put(AbilityController());
  final QuestProvider _questProvider = QuestProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quests'),
      ),
      body: ListView.builder(
        itemCount: _questProvider.quests.length,
        itemBuilder: (context, index) {
          final quest = _questProvider.quests[index];
          return ListTile(
            title: Text(quest.title),
            subtitle: Text(quest.description),
            onTap: () {
              // Assuming you have a function to update the user's stats in your database
              // You need to implement this function based on your database logic
              completeQuest(quest);
            },
          );
        },
      ),
    );
  }

  void completeQuest(Quest quest) {
    // Assuming you have a function in your database logic to update stats
    // You need to implement this function based on your database logic
    _abilityController.incrementAbilityName(quest.ability);

    // Update the UI
    setState(() {
      _questProvider.quests.remove(quest);
    });
  }
}
