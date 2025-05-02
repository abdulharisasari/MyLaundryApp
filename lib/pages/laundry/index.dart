import 'package:flutter/material.dart';

class MyLaundryPage extends StatefulWidget {
  const MyLaundryPage({super.key});

  @override
  State<MyLaundryPage> createState() => _MyLaundryPageState();
}

class _MyLaundryPageState extends State<MyLaundryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              children: [
                Text("My Laundry"),
              ],
          ),
        ),
      ),
    );
  }
}