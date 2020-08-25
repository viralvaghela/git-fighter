import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:git_fighter/models/winner_data.dart';
import 'package:http/http.dart' as http;

class Winner extends StatefulWidget {
  String winner;

  Winner(String winner) {
    this.winner = winner;
  }

  @override
  _WinnerState createState() => _WinnerState(winner);
}

class _WinnerState extends State<Winner> {
  WinnerData winnerData;
  String winner;

  _WinnerState(String winner) {
    this.winner = winner;
  }

  @override
  void initState() {
    super.initState();
    getProfileData();
    setState(() {});
  }

  void getProfileData() async {
    var response = await http.get("https://api.github.com/users/$winner");
    var jsonData = await jsonDecode(response.body);
    setState(() {
      winnerData = WinnerData.fromJson(jsonData);

    });
  }

  @override
  Widget build(BuildContext context) {
 /* return Container(color: Colors.white,);*/
    return Scaffold(
      appBar: AppBar(

        title:Text("🥇 Winner is $winner 🥇 "),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 15),
              child: IconButton(
                onPressed: () {},
                icon: FaIcon(FontAwesomeIcons.github, size: 50),
              )),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width - 20,
            left: 10.0,
            top: MediaQuery.of(context).size.height * 0.1,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  winnerData.bio != null
                      ? Text(
                          "${winnerData.bio}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                  winnerData.blog != null
                      ? Text(
                          "${winnerData.blog}  ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),

                  winnerData.company != null
                      ? Text(
                          "${winnerData.company}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                  //get weakness
                  Text(
                    "Followers : ${winnerData.followers}",
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 150.0,
              width: 150.0,
              child: winnerData.avatarUrl != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage("${winnerData.avatarUrl}"),
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                    )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
