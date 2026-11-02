import 'package:flutter/material.dart';
import '/board_stuff/components/piece.dart';
import '/board_stuff/values/colors.dart';

/*
Clase de casilla como widget para desplegar en pantalla (puede tener una pieza o no puede tenerla)
*/

class Square extends StatelessWidget{
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;

  const Square({
    super.key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    required this.onTap,
    required this.isValidMove,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor;

    // si seleccionado, cambiamos el color
    if (isSelected){
      squareColor = Color.fromARGB(255, 255, 241, 115);
    }
    else if ( isValidMove ){
      squareColor = Color.fromARGB(255, 255, 250, 201);
    }
    else{
      squareColor = isWhite ? foregroundColor : backgroundColor;
    }
    // en cualquier otro caso, de los colores de fondo

  // Se actua segun si se ha clicado o no
  return GestureDetector(
    onTap: onTap,
    child: Container(
      color: squareColor,
      child: piece != null ? Image.asset(
        piece!.imagePath,
        color: piece!.isWhite ? Colors.white : Colors.black,
        ) : null,
      ),
    );
  }
}