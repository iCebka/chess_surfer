import 'package:flutter/material.dart';

/*
Pieza capturada, se usaba para representar las piezas capturadas sobre el tablero, pero al final se descartó de la GUi final
*/

class DeadPiece extends StatelessWidget{
  final String imagePath;
  final bool isWhite;
  const DeadPiece({
    super.key, 
    required this.imagePath, 
    required this.isWhite
  });

  @override
  Widget build(BuildContext context){
    return Image.asset(
      imagePath,
      color: isWhite ? Colors.white : Colors.black,
    );
  }
}