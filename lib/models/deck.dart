import 'package:mp3/utils/db_helper.dart';

class Flashcard{
  int? id;
  String question;
  String answer;
  int? deckId;

  Flashcard({
    this.id,
    required this.question,
    required this.answer,
    this.deckId,
  });

  factory Flashcard.fromJson(dynamic json){
    return Flashcard(
      question: json['question'] as String, 
      answer: json['answer'] as String,);
      //deckId: id,);
  }

  factory Flashcard.clone(Flashcard source){
    return Flashcard(
      question: source.question, 
      answer: source.answer,);
      //deckId: source.deckId);
  }

  Future<void> dbSave() async {
    id = await DBHelper().insert('flashcards', {
      'question': question,
      'answer': answer,
      'deck_id': deckId,
    });
  }

  Future<void> dbUpdate() async {
    await DBHelper().update('flashcards', {
      'id': id,
      'question': question,
      'answer': answer,
      'deck_id': deckId,
    });
  }

}

class Deck {
  int? id;
  String title;
  List<dynamic> flashcards;
  // final String flashcards;

  Deck({
    this.id,
    required this.title,
    required this.flashcards,
  });

  factory Deck.fromJson(Map<String,dynamic> json) {
    return Deck(
      title: json['title'] as String,
      flashcards: json['flashcards'].map((e)=>Flashcard.fromJson(e)).toList() as List<dynamic>,
    );
  }

  factory Deck.clone(Deck source){
    return Deck(
      title: source.title,
      flashcards: source.flashcards.map((e)=>Flashcard.clone(e)).toList()
    );
  }

  Future<void> dbSave() async {
    id = await DBHelper().insert('deck', {
      'title': title,
    });
  }

  Future<void> dbUpdate() async {
    await DBHelper().update('deck', {
      'id': id,
      'title': title,
    });
  }
}