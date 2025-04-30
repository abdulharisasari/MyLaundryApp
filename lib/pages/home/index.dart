import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final void Function(int) onTapMenuItem;
  final bool isGuest;
  const HomePage({Key? key, required this.onTapMenuItem, required this.isGuest}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal:20),
          child: Container(
            child: Column(
                children: [
                Row(
                  children: [
                    Icon(Icons.menu),
                    Text("texttttttttttttttttt"),
                    Text("texttttttttttttttttt"),
                    Text("texttttttttttttttttt"),
                    Text("texttttttttttttttttt"),
                    Text("texttttttttttttttttt"),


                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

