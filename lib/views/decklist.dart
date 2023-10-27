
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mp3/models/deck.dart';
import 'package:mp3/models/notifier.dart';
// import 'package:mp3/utils/db_helper.dart';
import 'package:mp3/views/deckview.dart';
import 'package:mp3/views/editdeck.dart';
import 'package:mp3/views/flashcards.dart';
import 'package:provider/provider.dart';

class DeckList extends StatelessWidget{

  const DeckList({super.key});

  Future<List<Deck>> _loadDataFromJson() async {
    final data = rootBundle.loadString('assets/flashcards.json');
 
    // await Future.delayed(const Duration(seconds: 5));

    List<dynamic> dynamicList = json.decode(await data);

    List<Deck> decks = [];

    for(int i=0;i<dynamicList.length;i++){
      decks.add(Deck.fromJson(dynamicList[i]));
      await decks[i].dbSave();
      for(int j=0;j<decks[i].flashcards.length;j++){
        decks[i].flashcards[j].deckId = decks[i].id;
        //Flashcard fc = deck.flashcards[i]
        await decks[i].flashcards[j].dbSave();
      }
    }


    // await DBHelper().deleteAll('flashcards', 2);
    // await DBHelper().deleteAll('flashcards', 3);
    // await DBHelper().deleteAll('flashcards', 1);
    // await DBHelper().delete('deck', 1);
    // await DBHelper().delete('deck', 2);
    // await DBHelper().delete('deck', 3);
    

    // final data2 = await DBHelper().query('deck');
    // final data3 = await DBHelper().query('flashcards');//,where: 'deck_id = 1');
    // print(data2);
    // print(data3);


    return decks;
  }

  @override
  Widget build(BuildContext context) {
    
    final decks = Provider.of<List<Deck?>>(context);
    //final decks = initialDecks.map((deck) => Deck.clone(deck!)).toList();
    //ecks.addAll(initialDecks);
    final Notifier notifier = Notifier();
    
    if (decks.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Flashcard Decks'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.download,
                color: Colors.white,
              ),
              onPressed: () async {
                decks.addAll(await _loadDataFromJson());
                // decks.addAll(initialDecks.map((deck) => Deck.clone(deck!)).toList());
                notifier.refreshDeck();
                print('download clicked');
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return EditDeck(decks: decks, onPressSave: (){notifier.refreshDeck();}, isEdit: false,);
                }
              ),
            );
            print('Add button clicked');
          }, 
        ),
        body: ListenableBuilder(listenable: notifier,
              builder: (BuildContext context, Widget? child){
              return GridView.count(
                crossAxisCount: ((MediaQuery.of(context).size.width ~/ 300) + 1).toInt(),
                padding: const EdgeInsets.all(4),
                children: decks.map((e) => DeckView(totalCards: e!.flashcards.length, title : e.title,onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return Flashcards(deck: e, notifier: notifier,onPressSort: () {
                              notifier.toggleSort();
                            },onPressToggle: () {
                              notifier.toggleColor();
                              },);
                          }
                        ),
                      );
                      }, color: false,
                      onPressEdit: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return EditDeck(deck: e,decks: decks,
                                    onPressSave: (){notifier.refreshDeck();},
                                    isEdit: true,
                                    onPressDelete: () {
                                      notifier.refreshDeck();
                                    },
                                    );
                                }
                              ),
                            );
                          },)
                ).toList()
              );
            })
      );
    }
  }

}