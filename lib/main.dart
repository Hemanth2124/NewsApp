import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/homepage.dart';
import 'package:my_flutter_app/loginpage.dart';
import 'package:my_flutter_app/profilepage.dart';
import 'package:my_flutter_app/savedpage.dart';
import 'package:my_flutter_app/searchpage.dart';
import 'data.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedindex = 0;

  dynamic pages = [homepage(),SearchPage(), savedpage()];

  void itemtapped(int index) {
    setState(() {
      selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       home:Scaffold(
        appBar: AppBar(
          title: Text(
            "News App",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[100],
          leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => profilepage(),
                    ),
                  );
                },
                icon: Icon(Icons.person),
              );
            })
          ],
        ),
        body: pages[selectedindex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.black,
          currentIndex: selectedindex,
          onTap: itemtapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "saved",
            ),
          ],
        ),
       ),
    );
  }
}

