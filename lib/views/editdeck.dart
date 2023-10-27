import 'package:flutter/material.dart';
import 'package:mp3/models/deck.dart';
import 'package:mp3/utils/db_helper.dart';

class EditDeck extends StatelessWidget{

  final Deck? deck;
  final List<dynamic>? decks;
  final VoidCallback? onPressSave;
  final VoidCallback? onPressDelete;
  final int? index;
  final bool isEdit;

  const EditDeck({super.key, this.deck, this.onPressSave, this.index,this.decks, required this.isEdit, this.onPressDelete});

  @override
  Widget build(BuildContext context) {
    String question = index!=null ? index == -1 ? '': deck!.flashcards[index!].question : '';
    dynamic answer = index!=null ? index == -1 ? '': deck!.flashcards[index!].answer : '';
    return Scaffold(
      appBar: AppBar(
        title: Text(index!=null ? 'Edit Card' :'Edit Deck'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: TextFormField(
                initialValue: index!=null ? question : deck?.title,
                decoration: const InputDecoration(hintText: 'Name'),
                onChanged: (value) => (index!=null ? question = value : (deck==null) ? question = value : deck!.title = value),
              ),
            ),
            if(index!=null)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextFormField(
                  initialValue: answer,
                  decoration: const InputDecoration(hintText: 'Description'),
                  onChanged: (value) => answer = value,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text('Save'),
                  onPressed: () async {
                    if((deck==null && index==null && question=='') || (deck!=null && deck!.title=='') || (index!=null && (question == '' || answer == ''))){
                      showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.of(context).pop(true);
                        });
                        return const AlertDialog(
                          title: Text('Fields can not be empty'),
                        );
                      });
                    } else {
                      if(index!=null && index == -1){
                        Flashcard tempcard = Flashcard(question: question, answer: answer,deckId: deck!.id!);
                        await tempcard.dbSave();
                        deck!.flashcards.add(tempcard);
                        //deck!.flashcards.add({'question': question,'answer': answer});
                      } else if(index!=null){
                        deck!.flashcards[index!].question = question;
                        deck!.flashcards[index!].answer = answer;
                        await deck!.flashcards[index!].dbUpdate();
                      }
                      if(deck==null) {
                        Deck tempdeck = Deck(title: question, flashcards: []);
                        await tempdeck.dbSave();
                        decks!.add(tempdeck);
                      }
                      Navigator.of(context).pop(deck);
                      onPressSave!();
                    }
                  },
                ),
                if(isEdit)
                  TextButton(
                    child: const Text('Delete'),
                    onPressed: () async {
                      if(index!=null){
                        await DBHelper().delete('flashcards', deck!.flashcards[index!].id);
                        deck!.flashcards.removeAt(index!);
                      } else{
                        await DBHelper().deleteAll('flashcards', deck!.id!);
                        await DBHelper().delete('deck', deck!.id!);
                        decks!.remove(deck);
                      }
                      Navigator.of(context).pop(deck);
                      onPressDelete!();
                    },
                  ),
                
              ],
            )
        ],),
      ) 
    );
  }

}