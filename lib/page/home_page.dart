import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade200,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade200,
        centerTitle: true,
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Welcome to the app!'),
      ),
    );
  }
}
