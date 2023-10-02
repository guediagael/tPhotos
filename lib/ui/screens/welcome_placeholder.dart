import 'package:flutter/material.dart';

class PlaceHolderWelcomeScreen extends StatelessWidget {
  const PlaceHolderWelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Welcome To T-Photo, we'll help you to back up your photos"),
          ],
        ));
  }
}

