enum ChessPieceType { pawn, rook, knight, bishop, queen, king}

/*
Clase pieza que encapsula el tipo, el color y la ruta del recurso de imagen para dibujarlo en la pantalla
*/

class ChessPiece{
  final ChessPieceType type;
  final bool isWhite;
  final String imagePath;

  ChessPiece({
    required this.type, required this.isWhite, required this.imagePath
    });
}