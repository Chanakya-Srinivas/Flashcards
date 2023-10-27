import 'package:flutter/material.dart';
import 'views/dashboard.dart';

void main() async {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Dashboard(),
    title: 'Flashcard Decks',
  ));
}
