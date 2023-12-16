import 'package:cheyyan/ui/calander.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cheyyan/ui/theme.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Text(''),
            ),
            ListTile(
              title: const Text('Calendar'),
              onTap: () async {
                await Get.to(() => const HomePage());
              },
            ),
            ListTile(
              title: const Text('Quests'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Adventure'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () async {
                await Get.to(() => const Profile());
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
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
          actions: const [
            CircleAvatar(
              backgroundImage: AssetImage("images/profile.jpg"),
            ),
            SizedBox(
              width: 20,
            ),
          ]),
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [bluishClr, darkGreyClr],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.5, 0.9],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: darkGreyClr,
                      minRadius: 35.0,
                      child: const Icon(
                        Icons.call,
                        size: 30.0,
                      ),
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.white70,
                      minRadius: 60.0,
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: AssetImage("images/profile.jpg"),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: darkGreyClr,
                      minRadius: 35.0,
                      child: const Icon(
                        Icons.message,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Leonardo Palmeiro',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Flutter Developer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.deepOrange.shade300,
                    child: const ListTile(
                      title: Text(
                        '5000',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'Followers',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.red,
                    child: const ListTile(
                      title: Text(
                        '5000',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'Following',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: const Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'palmeiro.leonardo@gmail.com',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'GitHub',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'https://github.com/leopalmeiro',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Linkedin',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'www.linkedin.com/in/leonardo-palmeiro-834a1755',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
