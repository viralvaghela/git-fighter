import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:git_fighter/screens/winner_screen.dart';
import 'package:http/http.dart' as http;

class FightScreen extends StatefulWidget {
  @override
  _FightScreenState createState() => _FightScreenState();
}

class _FightScreenState extends State<FightScreen> {
  final TextEditingController txtUser1Controller = TextEditingController();

  final TextEditingController txtUser2Controller = TextEditingController();

  bool _loading = false;
  String winner;
  var responseUser1, responseUser2;

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Scaffold(
            body: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Text(
                        "Please wait...Loading",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Text(
                        "Fighting the Git Users",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Git Fighter"),
            ),
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: txtUser1Controller,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        labelText: "User 1",
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        hintText: "Enter User 1 GitHub username",
                        hintStyle: TextStyle(fontSize: 13.0),
                        contentPadding: EdgeInsets.all(10),
                        prefixIcon: Icon(
                          Icons.person,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: txtUser2Controller,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        labelText: "User 2",
                        hintText: "Enter User 2 GitHub username",
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        hintStyle: TextStyle(fontSize: 13.0),
                        contentPadding: EdgeInsets.all(10),
                        prefixIcon: Icon(
                          Icons.person,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "FIGHT",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        setState(
                          () {
                            _loading = true;
                          },
                        );
                        startFight();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  void startFight() async {
    if (txtUser1Controller.text == "" || txtUser2Controller.text == "")
      return;
    else {
      responseUser1 = await http
          .get("https://api.github.com/users/${txtUser1Controller.text}");
      responseUser2 = await http
          .get("https://api.github.com/users/${txtUser2Controller.text}");
      var jsonData1 = jsonDecode(responseUser1.body);
      var jsonData2 = jsonDecode(responseUser2.body);
      int user1Followers = jsonData1['followers'];
      int user2Followers = jsonData2['followers'];
      setState(
        () {
          if (user1Followers >= user2Followers)
            winner = txtUser1Controller.text;
          else
            winner = txtUser2Controller.text;
          print("winner is $winner");
          _loading = false;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Winner(winner),
            ),
          );
        },
      );
    }
  }
}
