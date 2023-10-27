import 'package:mp3/utils/db_helper.dart';

class DbFlashcard{
  int? id;
  String question;
  String answer;
  int deckId;

  DbFlashcard({
    this.id,
    required this.question,
    required this.answer,
    required this.deckId,
  });

  factory DbFlashcard.fromJson(dynamic json,int id){
    return DbFlashcard(
      question: json['question'] as String, 
      answer: json['answer'] as String,
      deckId: id,);
  }

  factory DbFlashcard.clone(DbFlashcard source){
    return DbFlashcard(
      question: source.question, 
      answer: source.answer,
      deckId: source.deckId);
  }

  Future<void> dbSave() async {
    id = await DBHelper().insert('flashcards', {
      'question': question,
      'answer': answer,
      'deck_id': deckId,
    });
  }

  Future<void> dbDelete() async {
    if (id != null) {
      await DBHelper().delete('flashcards', id!);
    }
  }

}

class DbDeck {
  int? id;
  String title;
  //List<dynamic> flashcards;
  // final String flashcards;

  DbDeck({
    this.id,
    required this.title,
  });

  factory DbDeck.fromJson(Map<String,dynamic> json) {
    return DbDeck(
      title: json['title'] as String,
    );
  }

  factory DbDeck.clone(DbDeck source){
    return DbDeck(
      title: source.title,
    );
  }

  Future<void> dbSave() async {
    id = await DBHelper().insert('deck', {
      'title': title,
    });
  }

  Future<void> dbDelete() async {
    if (id != null) {
      await DBHelper().delete('deck', id!);
    }
  }
}