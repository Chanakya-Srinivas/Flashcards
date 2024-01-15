import 'package:flutter/material.dart';
import 'package:mp3/models/deck.dart';
import 'package:mp3/models/notifier.dart';
import 'package:mp3/views/deckview.dart';

class QuizBoard extends StatelessWidget{

  final Deck? deck;
  final Notifier? notifier;

  const QuizBoard({super.key, this.deck, this.notifier});

  @override
  Widget build(BuildContext context) {
    var randomPicker = List<int>.generate(deck!.flashcards.length, (i) => i)..shuffle();
    bool flag = false;
    var visit = <dynamic>{};
    var seen = <dynamic>{};
    print(randomPicker.toSet().length);
    return Scaffold(
      appBar: AppBar(
        title: Text('${deck!.title} Quiz'),
      ),
      body: ListenableBuilder(listenable: notifier!, builder: (BuildContext context, Widget? child){
        visit.add(notifier!.index);
        if(flag){
          seen.add(notifier!.index);
        }
        return Column(
           //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: (MediaQuery.of(context).size.height * 0.01).toDouble(),),
            Center(
              child: SizedBox(
                height: (MediaQuery.of(context).size.height * 0.5).toDouble(),
                width: (MediaQuery.of(context).size.width * 0.95).toDouble(),
                child: DeckView(color: flag,flashcards: deck!.flashcards[randomPicker[notifier!.index]],)
              ),
            ),
             SizedBox(
                height: (MediaQuery.of(context).size.height * 0.3).toDouble(),
                width: (MediaQuery.of(context).size.width * 0.95).toDouble(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          notifier!.index--;
                          if(notifier!.index < 0) {
                            notifier!.index = deck!.flashcards.length-1;
                          }
                          flag = false;
                          print('Previous question');
                          notifier!.changeIndex();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          (flag)? Icons.copy_rounded: Icons.copy_all,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          flag = !flag;
                          notifier!.refreshDeck();
                          print('revel answet');
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          notifier!.index++;
                          if(notifier!.index == deck!.flashcards.length) {
                            notifier!.index=0;
                          }
                          flag = false;
                          print('Next question');
                          notifier!.changeIndex();
                        },
                      )
                    ],),
                    Text('Seen ${visit.length} of ${deck!.flashcards.length} cards'),
                    const SizedBox(height: 10,),
                    Text('Peaked at ${seen.length} of ${visit.length} answers'),
                  ],
                )
            ),
            
          ],
        );}),
    );
  }

}