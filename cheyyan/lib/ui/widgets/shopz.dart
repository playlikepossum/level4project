import 'dart:convert';
import 'dart:math';
import 'package:cheyyan/ui/profile.dart';
import 'package:cheyyan/ui/quests.dart';
import 'package:cheyyan/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wifi_ip_details/wifi_ip_details.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:wifi_ip_details/wifi_ip_details.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  String url = '';
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
    {'title': 'The Iliad', 'author': 'Homer'},
    {'title': 'The Odyssey', 'author': 'Homer'}
    // More books...
  ];

  @override
  void initState() {
    super.initState();
    generateRandomBooks();
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
    String? target = '192.168.1.98:5000';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
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
            // Display three random book titles
            for (var book in randomBooks)
              ElevatedButton(
                onPressed: () => _startDownload(book['title'], book['author']),
                child: Text(book['title']),
              ),
            SizedBox(height: 20.0), // Add some spacing between the buttons
            // Button to generate new random books

            ElevatedButton(
              onPressed: () {
                setState(() {
                  generateRandomBooks();
                });
              },
              child: Text('Generate New Random Books'),
            ),
          ],
        ),
      ),
    );
  }
}
