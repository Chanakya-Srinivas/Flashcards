import 'package:flutter/material.dart';
import 'package:mp3/models/deck.dart';
import 'package:mp3/models/notifier.dart';
import 'package:mp3/views/deckview.dart';
import 'package:mp3/views/editdeck.dart';
import 'package:mp3/views/quizboard.dart';


class Flashcards extends StatelessWidget{

  final Deck? deck;
  final VoidCallback? onPressSort;
  final VoidCallback? onPressToggle;
  final Notifier notifier;

  const Flashcards({super.key, this.onPressSort, required this.notifier, this.onPressToggle, this.deck});

  @override
  Widget build(BuildContext context) {
    List<Flashcard> originalList = [];
    notifier.isSort = false;
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: (){
              if(originalList.isNotEmpty) {
                for(int i=originalList.length;i<deck!.flashcards.length;i++){
                  originalList.add(deck!.flashcards[i]);
                }
                deck!.flashcards = originalList;
              }
              Navigator.pop(context, false);
            },
          ),
          title: Text(deck!.title),
          actions: <Widget>[
            IconButton(
              icon: ListenableBuilder(listenable: notifier,
                builder: (BuildContext context, Widget? child){
                  return Icon(
                  (notifier.isSort) ? Icons.access_time_outlined : Icons.sort_by_alpha,
                  color: Colors.white,
                );
                }) ,
              onPressed: () {
                if(notifier.isSort) {
                  for(int i=originalList.length;i<deck!.flashcards.length;i++){
                    originalList.add(deck!.flashcards[i]);
                  }
                  deck!.flashcards.clear();
                  deck!.flashcards.addAll(originalList.toList());
                  originalList.clear();
                } else {
                  for(int i=0;i<deck!.flashcards.length;i++){
                    originalList.add(deck!.flashcards[i]);
                  }
                  // originalList.addAll(deck!.flashcards as Iterable<Flashcard>);
                  deck!.flashcards.sort((a, b) => a.question.compareTo(b.question));
                }
                print('sort clicked');
                onPressSort!();
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () {
                print('play quiz clicked');
                if(deck!.flashcards.isNotEmpty) {
                  notifier.index=0;
                  Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return QuizBoard(deck: deck,notifier: notifier,);
                    }
                  ),
                );
                }
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
                  return EditDeck(deck: deck, index: -1,onPressSave: (){notifier.refreshDeck();}, isEdit: false,);
                }
              ),
            );
            print('Add button clicked');
          }, 
        ),
        body: ListenableBuilder(listenable: notifier,
              builder: (BuildContext context, Widget? child){
                return GridView.count(
                  crossAxisCount: ((MediaQuery.of(context).size.width ~/ 200) + 1).toInt(),
                  padding: const EdgeInsets.all(4),
                  children : List.generate(deck!.flashcards.length, (i){
                    return DeckView(color: false,flashcards: deck!.flashcards[i],onPressed: () {
                      //color[i] = !color[i];
                      //onPressToggle!();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            var removeCard = deck!.flashcards[i];
                            return EditDeck(deck: deck, index: i,
                              onPressSave: (){
                                notifier.refreshDeck();
                              },
                              isEdit: true,
                              onPressDelete: () {
                                originalList.remove(removeCard);
                                notifier.refreshDeck();
                              },);
                          }
                        ),
                      );
                    },);
                  }),
                );
            })
      );
  }

}