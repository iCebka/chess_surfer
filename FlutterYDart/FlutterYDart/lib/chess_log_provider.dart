import 'package:flutter/material.dart';

/*
Se define ChessLog como una clase que genera ValueNotifiers de tipo String, esto permitirá que 
cada vez que el log de jugadas sea actualizado al mover una pieza, se notifique a los widgets que usan su información
para desplegar algo en pantalla
*/

class ChessLog extends ValueNotifier<String> {
  ChessLog(String value) : super(value);

  void setLog(String value) {
    this.value = value;
    notifyListeners();
  }
}