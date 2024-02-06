import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
      randomBooks.add(generateRandomBook(books));
    }
  }

  Future<void> _startDownload(String title) async {
    final response = await http
        .get(Uri.parse('http://192.168.1.98:5000/search?title_name=$title'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      Map<String, dynamic> jsonMap = jsonDecode(response.body);

      Map<String, dynamic> downloadLinks = jsonMap['download_links'];

      String url = downloadLinks['GET'];

      final Uri data = Uri.parse(url);
      if (!await launchUrl(data)) {
        throw Exception('Could not launch the pdf');
      }
      // _flutterMediaDownloaderPlugin.downloadMedia(context, url);
    }
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
        title: Text('Download Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display three random book titles
            for (var book in randomBooks)
              ElevatedButton(
                onPressed: () => _startDownload(book['title']),
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
