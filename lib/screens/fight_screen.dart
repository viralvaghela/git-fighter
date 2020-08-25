import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:git_fighter/screens/home_screen.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Git Fighter"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: txtUser1Controller,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                  labelText: "User 1",
                  contentPadding: EdgeInsets.all(10),
                  prefixIcon: Icon(
                    Icons.person,
                    size: 30,
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  onPressed: () {
                    setState(() {
                      _loading = true;
                    });
                    startFight();
                  },
                  child: Text(
                    "Fight",
                    style: TextStyle(fontSize: 20),
                  ),
                  color: Colors.red,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
            ),
            TextField(
              controller: txtUser2Controller,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                  labelText: "User 2",
                  contentPadding: EdgeInsets.all(10),
                  prefixIcon: Icon(
                    Icons.person,
                    size: 30,
                  )),
            ),
            _loading ? CircularProgressIndicator() : Container()
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
      int user1Followers=jsonData1['followers'];
      int user2Followers=jsonData2['followers'];
      setState(() {
        if(user1Followers>=user2Followers)
          winner=txtUser1Controller.text;
        else
          winner=txtUser2Controller.text;
        print("winner is $winner");
        _loading = false;

        Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => Winner(winner)));

      });
    }
  }
}
