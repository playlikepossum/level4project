import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';

import 'package:http/http.dart' as http;

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final _flutterMediaDownloaderPlugin = MediaDownload();
  String url = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _startDownload() async {
    String authorName = 'Jane Austen';

    final response = await http.get(Uri.parse(
        'http://192.168.1.98:5000/search_author?author_name=$authorName'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      Map<String, dynamic> jsonMap = jsonDecode(response.body);

      Map<String, dynamic> downloadLinks = jsonMap['download_links'];

      String cloudflareLink = downloadLinks['Cloudflare'];

      url = cloudflareLink;
      _flutterMediaDownloaderPlugin.downloadMedia(context, url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _startDownload,
          child: Text('Start Download'),
        ),
      ),
    );
  }
}
