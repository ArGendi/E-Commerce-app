import 'package:flutter/cupertino.dart';

class ModelHud extends ChangeNotifier {
  bool loading = false;

  changeLoadingValue(bool value){
    loading = value;
    notifyListeners();
  }
}