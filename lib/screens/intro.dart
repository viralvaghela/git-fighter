import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<PageViewModel> getPages() {
      return [
        PageViewModel(
            title: "Git Fighter",
            body: "Fight ",
            image: Image.network(
                "https://cdn.iconscout.com/icon/free/png-256/github-153-675523.png")),
      ];
    }

    return SafeArea(
      child: IntroductionScreen(
        pages: getPages(),
        onDone: () {},
        done: Text("Done"),
      ),
    );
  }
}
