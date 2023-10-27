import 'package:flutter/widgets.dart';

class Notifier with ChangeNotifier{

  bool isSort=false;
  int index = 0;

  void toggleSort(){
    isSort = !isSort;
    notifyListeners();
  }

  void toggleColor(){
    notifyListeners();
  }

  void refreshDeck(){
    notifyListeners();
  }

  void changeIndex(){
    notifyListeners();
  }

}