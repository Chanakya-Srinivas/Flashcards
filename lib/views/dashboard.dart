import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mp3/models/deck.dart';
import 'package:mp3/utils/db_helper.dart';
import 'package:mp3/views/decklist.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});


  Future<List<Deck>> _loadDataFromDB(BuildContext context) async {

    // await DBHelper().deleteAll('flashcards', 2);
    // await DBHelper().deleteAll('flashcards', 3);
    // await DBHelper().deleteAll('flashcards', 1);
    // await DBHelper().delete('deck', 1);
    // await DBHelper().delete('deck', 2);
    // await DBHelper().delete('deck', 3);
    

    final deckDb= await DBHelper().query('deck');
    List<Deck> decks = [];
    
    if(deckDb.isNotEmpty){
      print('from db');
      for(int i=0;i<deckDb.length;i++){
        final flashcardsDb = await DBHelper().query('flashcards',where: 'deck_id = ${deckDb[i]['id'] as int}');
        final List<Flashcard> temp = flashcardsDb.map((e) => Flashcard(
          id: e['id'] as int,
          question: e['question'] as String,
          answer: e['answer'] as String,
          deckId: e['deck_id'] as int)).toList();
        
        decks.add(Deck(
          id: deckDb[i]['id'] as int,
          title: deckDb[i]['title'] as String, flashcards: temp,));
      }
    } else {
      print('from json');
      final data = await DefaultAssetBundle.of(context)
        .loadString('assets/flashcards.json');

      List<dynamic> dynamicList = json.decode(data);

      for(int i=0;i<dynamicList.length;i++){
        decks.add(Deck.fromJson(dynamicList[i]));
        await decks[i].dbSave();
        for(int j=0;j<decks[i].flashcards.length;j++){
          decks[i].flashcards[j].deckId = decks[i].id;
          //Flashcard fc = deck.flashcards[i]
          await decks[i].flashcards[j].dbSave();
        }
      }

    }
    await Future.delayed(const Duration(seconds: 5));
    
    // List<Future<Deck>> decks = deckDb.map((e) async {
    //   Deck d = Deck(
    //     id: e['id'] as int,
    //     title: e['title'] as String, flashcards: [],);
    //   final flashcardsDb = await DBHelper().query('flashcards',where: 'deck_id = ${d.id}');
    //   d.flashcards.addAll(flashcardsDb.map((e) => Flashcard(
    //     id: e['id'] as int,
    //     question: e['question'] as String,
    //     answer: e['answer'] as String,
    //     deckId: e['deck_id'] as int)).toList());
    //   return d;
    // }).toList();

    return decks;
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureProvider<List<Deck?>>(
        create: (context) => _loadDataFromDB(context),
        initialData: [],
        child: const DeckList(),
      ),
    );
  }
}
