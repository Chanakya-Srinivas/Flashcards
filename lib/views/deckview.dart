import 'package:flutter/material.dart';
import 'package:mp3/models/deck.dart';

class DeckView extends StatefulWidget{

  final String? title;
  final int? totalCards;
  final Flashcard? flashcards;
  final VoidCallback? onPressed;
  final VoidCallback? onPressEdit;
  final bool color;

  const DeckView({super.key, this.title, this.flashcards, this.onPressed, required this.color, this.onPressEdit, this.totalCards});

  @override
  State<StatefulWidget> createState() => DeckView2();

}

class DeckView2 extends  State<DeckView>{


  @override
  Widget build(BuildContext context) {
    return Card(
            color: widget.color ? Colors.grey :Colors.purple[100],
            child: Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  InkWell(onTap: (widget.onPressed) == null ? null : () {
                    print('${widget.flashcards?.question} tapped');
                    widget.onPressed!();
                  },
                  child: Center(child: Text(widget.flashcards != null ? widget.color ? '${widget.flashcards?.answer}' : '${widget.flashcards?.question}' :'${widget.title}\n(${widget.totalCards} cards)',textAlign: TextAlign.center)),
                  ),
                  
                  if(widget.flashcards == null)
                      Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          widget.onPressEdit!();
                        },
                      ),
                    ),
                  
                ],
              )
            )
          );
  }

}