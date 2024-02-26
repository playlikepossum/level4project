import 'dart:convert';
import 'dart:math';
import 'package:cheyyan/controllers/ability_controller.dart';
// import 'package:cheyyan/models/abilities.dart';
// import 'package:cheyyan/ui/profile.dart';
// import 'package:cheyyan/ui/quests.dart';
// import 'package:cheyyan/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wifi_ip_details/wifi_ip_details.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:wifi_ip_details/wifi_ip_details.dart';

class Book {
  final String title;
  final String author;

  Book({
    required this.title,
    required this.author,
  });
}

class Level {
  bool claimed;
  String currentLevel;
  double progress;
  double maxLevel;
  double level;
  double savedLevel;
  int barrier;

  Level(
      {required this.currentLevel,
      required this.claimed,
      required this.progress,
      required this.maxLevel,
      required this.level,
      required this.savedLevel,
      required this.barrier});
}

class LevelProvider {
  final List<Level> levels = [
    Level(
        claimed: false,
        currentLevel: '1',
        progress: 0.0,
        maxLevel: 0.0,
        level: 0.0,
        savedLevel: 1.0,
        barrier: 2),
  ];

  LevelProvider() {
    _loadLevel();
  }

  Future<void> _loadLevel() async {
    final prefs = await SharedPreferences.getInstance();
    for (var level in levels) {
      level.claimed = prefs.getBool("claimed") ?? false;
      level.currentLevel = prefs.getString("currentLevel") ?? '1';
      level.progress = prefs.getDouble("progress") ?? 0.0;
      level.maxLevel = prefs.getDouble("maxLevel") ?? 0.0;
      level.level = prefs.getDouble("level") ?? 0.0;
      level.savedLevel = prefs.getDouble("savedLevel") ?? 1.0;
      level.barrier = prefs.getInt("barrier") ?? 2;
    }
  }

  Future<bool> getBoolData(SharedPreferences prefs, String key) async {
    return prefs.getBool(key) ?? false;
  }

  Future<String> getStringData(SharedPreferences prefs, String key) async {
    return prefs.getString(key) ?? '1';
  }

  Future<double> getDoubleData(SharedPreferences prefs, String key) async {
    return prefs.getDouble(key) ?? 0.0;
  }

  Future<int> getIntData(SharedPreferences prefs, String key) async {
    return prefs.getInt(key) ?? 2;
  }

  Future<void> setclaimed(Level level) async {
    level.claimed = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("claimed", level.claimed);
  }

  Future<void> setCurrentLevel(Level level, int num) async {
    level.currentLevel = num.toString();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("currentLevel", level.currentLevel);
  }

  Future<void> setProgress(Level level, double num) async {
    level.progress = num;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("progress", level.progress);
  }

  Future<void> setMaxLevel(Level level, double num) async {
    level.maxLevel = num;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("maxLevel", level.maxLevel);
  }

  Future<void> setLevel(Level level, double num) async {
    level.level = num;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("level", level.level);
  }

  Future<void> setSavedLevel(Level level, double num) async {
    level.savedLevel = num;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("savedLevel", level.savedLevel);
  }

  Future<void> setBarrier(Level level, int num) async {
    level.barrier = num;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("barrier", level.barrier);
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  String url = '';
  final AbilityController _abilityController = Get.find();
  LevelProvider levelProvider = LevelProvider();

  bool? claimed;
  String? currentLevel;
  double? progress;
  double? maxLevel;
  double? level;
  double? savedLevel;
  int barrier = 1;
  List<Level> get levelz => levelProvider.levels;
  Level get levelz2 => levelProvider.levels[0];
  List<Map<String, dynamic>> randomBooks = [];
  List<Map<String, dynamic>> books = [
    {'title': 'Pride and Prejudice', 'author': 'Jane Austen'},
    {'title': 'Jane Eyre', 'author': 'Charlotte Brontë'},
    {'title': 'Moby-Dick', 'author': 'Herman Melville'},
    {'title': 'Frankenstein', 'author': 'Mary Shelley'},
    {'title': 'The Picture of Dorian Gray', 'author': 'Oscar Wilde'},
    {'title': 'Great Expectations', 'author': 'Charles Dickens'},
    {'title': 'Dracula', 'author': 'Bram Stoker'},
    {'title': 'War and Peace', 'author': 'Leo Tolstoy'},
    {'title': 'Sense and Sensibility', 'author': 'Jane Austen'},
    {'title': 'Wuthering Heights', 'author': 'Emily Brontë'},
    {
      'title': '''Alice's Adventures in Wonderland''',
      'author': 'Lewis Carroll'
    },
    {'title': 'The Hound of the Baskervilles', 'author': 'Arthur Conan Doyle'},
    {'title': 'Les Misérables', 'author': 'Victor Hugo'},
    {'title': 'To Kill a Mockingbird', 'author': 'Harper Lee'},
    {'title': 'The Brothers Karamazov', 'author': 'Fyodor Dostoevsky'},
    {
      'title': 'The Adventures of Sherlock Holmes',
      'author': 'Arthur Conan Doyle'
    },
    {'title': 'Emma', 'author': 'Jane Austen'},
    {'title': 'Oliver Twist', 'author': 'Charles Dickens'},
    {'title': 'The Scarlet Letter', 'author': 'Nathaniel Hawthorne'},
    {'title': 'Anna Karenina', 'author': 'Leo Tolstoy'},
    {'title': 'The Count of Monte Cristo', 'author': 'Alexandre Dumas'},
    {'title': 'Treasure Island', 'author': 'Robert Louis Stevenson'},
    {'title': 'Walden', 'author': 'Henry David Thoreau'},
    {'title': 'The Odyssey', 'author': 'Homer'},

    // More books...
  ];

  @override
  void initState() {
    super.initState();
    print('init state called');
    _abilityController.getAbilities();
    generateRandomBooks();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // You can safely use ancestor here
    super.dispose();
  }

  void generateRandomBooks() {
    // Clear the existing list

    randomBooks.clear();

    // Generate three random books
    for (int i = 0; i < 3; i++) {
      Map<String, dynamic> book = generateRandomBook(books);
      while (randomBooks.contains(book)) {
        book = generateRandomBook(books);
      }
      randomBooks.add(book);
    }
  }

  Future<void> _startDownload(String title, String author) async {
    String? target = 'specks76.pythonanywhere.com';
    final response = await http.get(Uri.parse(
        'http://$target/search?title_name=$title&author_name=$author'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);

      List<dynamic> results = jsonMap['results'];

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select a book to download'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(results[index]['Title']),
                    onTap: () async {
                      final response2 = await http.get(Uri.parse(
                          'http://$target/search?title_name=$title&author_name=$author&link=$index'));
                      Map<String, dynamic> jsonMap2 =
                          jsonDecode(response2.body);

                      Map<String, dynamic> results2 =
                          jsonMap2['download_links'];

                      // Download the selected book
                      String downloadLink = results2["GET"];
                      final Uri data = Uri.parse(downloadLink);
                      if (!await launchUrl(data)) {
                        throw Exception('Could not launch the pdf');
                      }
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          );
        },
      );
    }

    // If the server returns a 200 OK response, parse the JSON
  }

  Map<String, dynamic> generateRandomBook(List<Map<String, dynamic>> books) {
    // Create a new Random instance
    var random = Random();

    // Generate a random index
    int randomIndex = random.nextInt(books.length);

    // Return the book at the random index
    return books[randomIndex];
  }

  void _showRandomBooksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Random Books'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (var book in randomBooks)
                ListTile(
                  title: Text(book['title']),
                  subtitle: Text(book['author']),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    _startDownload(book['title'], book['author']);
                  },
                ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Future<void> updateLevelAndProgress(bool flag) async {
  //   Level levelz = levelProvider.levels[0];

  //   if (levelz.savedLevel == null) {
  //     // levelsavedLevel = 1.0;
  //     levelz.savedLevel = 1.0;
  //     levelProvider.setSavedLevel(levelz, levelz.savedLevel);
  //   }
  //   if (flag) {
  //     setState(() {
  //       barrier += 1;
  //       claimed = true;
  //       levelProvider.setBarrier(levelz, barrier);
  //       levelProvider.setclaimed(levelz);
  //     });

  //     print('flag barrier: $barrier');
  //   } else {
  //     for (var x in _abilityController.abilityList) {
  //       progress = x.exp.toDouble() - x.exp.floor().toDouble();
  //       maxLevel = x.exp.ceil().toDouble() - x.exp.floor().toDouble();
  //       if (progress == 0.0 && maxLevel == 0.0) {
  //         maxLevel = maxLevel! + 1.0;
  //       }
  //       currentLevel = x.exp.floor().toInt().toString();

  //       level = x.exp.toDouble();
  //       print('level: $level');
  //       print('savedlevel: $savedLevel');
  //       if (level! > levelz.savedLevel! && level! > barrier) {
  //         setState(() {
  //           claimed = false;
  //           levelProvider.setclaimed(levelz);
  //           levelz.savedLevel = level!;
  //           levelProvider.setSavedLevel(levelz, levelz.savedLevel);
  //         });
  //       } else {
  //         setState(() {
  //           claimed = true;
  //         });
  //       }
  //       setState(() {
  //         level = x.exp.toDouble();
  //         progress = x.exp.toDouble() - x.exp.floor().toDouble();
  //         maxLevel = x.exp.ceil().toDouble() - x.exp.floor().toDouble();
  //         currentLevel = x.exp.floor().toInt().toString();
  //         savedLevel = savedLevel;
  //       });
  //       print('Newsavedlevel: $savedLevel');
  //       print('barrier: $barrier');
  //       print('claimed2: $claimed');
  //       print('progress: $progress');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    for (var x in _abilityController.abilityList) {
      progress = x.exp.toDouble() - x.exp.floor().toDouble();
      maxLevel = x.exp.ceil().toDouble() - x.exp.floor().toDouble();
      if (progress == 0.0 && maxLevel == 0.0) {
        maxLevel = maxLevel! + 1.0;
      }
      currentLevel = x.exp.floor().toInt().toString();

      level = x.exp.toDouble();
    }

    return FutureBuilder(
        future: levelProvider._loadLevel(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Rewards'),
                elevation: 0,
                backgroundColor: context.theme.colorScheme.background,
                leading: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Header with Image
                    Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        children: [
                          Text(
                            'Your Rewards Journey',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Level Progress
                    LinearProgressIndicator(
                      value: progress ?? 0.0,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    SizedBox(height: 10),
                    // Level Info
                    if (level! > barrier &&
                        progress! >= 0.0 &&
                        !levelz2.claimed!)
                      ElevatedButton(
                        onPressed: () {
                          if (level! > levelz2.savedLevel! &&
                              level! > barrier) {
                            setState(() {
                              claimed = false;
                              levelProvider.setclaimed(levelz2);
                              levelz2.savedLevel = level!;
                              levelProvider.setSavedLevel(
                                  levelz2, levelz2.savedLevel);
                            });
                          } else {
                            setState(() {
                              levelz2.claimed = true;
                            });
                          }

                          // updateLevelAndProgress(true);
                          _showRandomBooksDialog(context);
                          generateRandomBooks();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Text(
                                'Congratulations!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'You have reached level $currentLevel.',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Click here to claim your reward.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      // Level Progress Info
                      Column(
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'You are currently at level $currentLevel.',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Keep going to reach the next level!',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
