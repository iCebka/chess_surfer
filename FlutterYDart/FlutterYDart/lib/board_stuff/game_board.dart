import 'package:flutter/material.dart';
import 'components/square.dart';
import 'helper/helper_functs.dart';
import 'components/piece.dart';
import 'values/colors.dart';
import '../log.dart';

/*
Construimos el tablero de ajedrez como widget
*/

class GameBoard extends StatefulWidget{
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {

  //Lista de dos dimensiones que contiene posiblemente piezas de ajedrez
  late List<List<ChessPiece?>>board;

  ChessPiece? selectedPiece; // Pieza seleccionada para operar cambios de color en casillas

  int selectedRow = -1;
  int selectedCol = -1;

  //Lista de movimientos vaidos
  List<List<int>> validMoves = [];

  //lista de piezas capturadas
  List<ChessPiece>whitePiecesTaken = [];
  List<ChessPiece>blackPiecesTaken = [];
  bool checkStatus = false;

  //String chessLog = "";
  //turnos
  bool isWhiteTurn = true;

  //Posicion de los reyes para verificar jaques
  List<int>whiteKingPosition = [7,4];
  List<int>blackKingPosition = [0,4];

  //Mapas para construir la notacion algebraica con facilidad
  Map<int, String> rowsStrings = { 0: "8", 1: "7", 2: "6", 3: "5",
                                                            4: "4", 5: "3", 6: "2", 7: "1"};
  Map<int, String> colsStrings = { 0: "a", 1: "b", 2: "c", 3: "d",
                                                            4: "e", 5: "f", 6: "g", 7: "h"};  
  Map<String, String> initials = { "ChessPieceType.pawn" : "p", "ChessPieceType.rook": "R", "ChessPieceType.knight": "N", 
                                                          "ChessPieceType.bishop" : "B", "ChessPieceType.queen" : "Q", "ChessPieceType.king" : "K"};                                         

  @override
  void initState(){
    super.initState();
    _initializeBoard();
  }

  // INITIALIZE BOARRD
  void _initializeBoard(){
    // inicializamos el tablero con nulos
    List<List<ChessPiece?>> newBoard = List.generate(8, (index) => List.generate(8, (index) => null) );

    // Peones
    for (int i = 0; i < 8; i++){
      newBoard[1][i] = ChessPiece(
        type: ChessPieceType.pawn, 
        isWhite: false, 
        imagePath: 'lib/assets/images/bp.png',
      );
      newBoard[6][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: true,
        imagePath: 'lib/assets/images/wp.png',
      );
    }

    // Torres
    newBoard[0][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: 'lib/assets/images/wR.png',
    );
    newBoard[0][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: 'lib/assets/images/wR.png',
    );
    newBoard[7][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: 'lib/assets/images/wR.png',
    );
    newBoard[7][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: 'lib/assets/images/wR.png',
    );

    // Caballos
    newBoard[0][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: 'lib/assets/images/wN.png',
    );
    newBoard[0][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: 'lib/assets/images/wN.png',
    );
    newBoard[7][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: 'lib/assets/images/wN.png',
    );
    newBoard[7][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: 'lib/assets/images/wN.png',
    );

    // Alfiles
    newBoard[0][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: 'lib/assets/images/wB.png',
    );
    newBoard[0][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: 'lib/assets/images/wB.png',
    );
    newBoard[7][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: 'lib/assets/images/wB.png',
    );
    newBoard[7][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: 'lib/assets/images/wB.png',
    );

    // Damas
    newBoard[0][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: false,
      imagePath: 'lib/assets/images/wQ.png',
    );
    newBoard[7][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: true,
      imagePath: 'lib/assets/images/wQ.png',
    );

    // Reyes
    newBoard[0][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: false,
      imagePath: 'lib/assets/images/wK.png',
    );
    newBoard[7][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: true,
      imagePath: 'lib/assets/images/wK.png',
    );
    board = newBoard;
  }

  // El usuario selecciona una pieza
  void pieceSelected(int row, int col) {
    setState(() {//setState para actualizar el tablero
      if (selectedPiece == null && board[row][col] != null) {//si tocamos una casilla sin pieza y no tenemos seleccionada una pieza
        if (board[row][col]!.isWhite == isWhiteTurn){
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
      }
    //si tocamos una pieza del mismo color
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite){
            selectedPiece = board[row][col];
            selectedRow = row;
            selectedCol = col;
          }

      //Si tocamos una posicion vacia y esta es parte de los movimientos validos
      else if (selectedPiece != null && 
        validMoves.any( (element) => element[0] == row && element[1] == col)) {
            movePiece(row, col);
          }

      // Si tocaste una pieza, calcula sus movimientos validos     
      validMoves = 
        calculateRealValidMoves(selectedRow, selectedCol, selectedPiece, true);
    });
  }

  //REAL VALID MOVES
  List<List<int>> calculateRealValidMoves(int row, int col, ChessPiece? piece, bool checkSimulation){
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = calculatedRawValidMoves(row,col, piece);

    if (checkSimulation) {
      for (var move in candidateMoves){
        int endRow = move[0];
        int endCol = move[1];
        if (simulatedMoveIsSafe(piece!, row, col, endRow, endCol)){
          realValidMoves.add(move);
        }
      }
    } else{
      realValidMoves = candidateMoves;
    }
    return realValidMoves;
  }

  // Mover pieza
  void movePiece(int newRow, int newCol) {
    
    String algNotation = "";
    //capturas
    if (board[newRow][newCol] != null){
      var capturedPiece = board[newRow][newCol];
      if (capturedPiece!.isWhite){
        whitePiecesTaken.add(capturedPiece);
      }else{
        blackPiecesTaken.add(capturedPiece);
      }
    }

    if (selectedPiece!.type == ChessPieceType.king){
      if (selectedPiece!.isWhite){
        whiteKingPosition = [newRow, newCol];
      } else{
        blackKingPosition = [newRow, newCol];
      }
    }

    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    //Se construye la notacion algebraica de ajedrez
    if (selectedPiece!.type != ChessPieceType.pawn){
      algNotation = algNotation + initials[selectedPiece!.type.toString()]!;
    }
    algNotation = algNotation + colsStrings[newCol]! + rowsStrings[newRow]!;//algNotation = algNotation + initials[selectedPiece!.type.toString()]!;
    //print(algNotation);
    chessLog.value = chessLog.value + algNotation + "_";
    //print(chessLog.value);

    //testLook(chessLog);

    if (isKingInCheck(!isWhiteTurn)){
        checkStatus = true;
    } else {
      checkStatus = false;
    }

    setState( (){
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

    if (isCheckMate(!isWhiteTurn)){
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Mate"),
          actions: [
            TextButton(
              onPressed: resetGame, 
              child: const Text("Jugar de Nuevo")
              ),
          ],
        ),
      );
    }

    isWhiteTurn = !isWhiteTurn;
    //updateVariantes();
  }

  // Calcula los movimientos crudos
  List<List<int>> calculatedRawValidMoves(int row, int col, ChessPiece? piece){
    List<List<int>> candidateMoves = [];

    if (piece == null){
      return [];
    }

    // diferentes directions basada en el color
    int direction = piece.isWhite ? -1 : 1;


    switch(piece.type){
      case ChessPieceType.pawn:
      //puede moverse hacia delante en una posición no ocupada
        if (isInBoard(row + direction, col) &&
          board[row + direction][col] == null){
            candidateMoves.add( [row + direction, col] );
          }

        // dos hacia delante
        if ( (row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite) ) {
          if (isInBoard(row+2*direction,col) && 
              board[row + 2*direction][col] == null &&
              board[row + 2*direction][col] == null){
              candidateMoves.add( [row + 2 * direction, col] );
            }
        }
        // captura diagonal
        if (isInBoard(row + direction, col - 1) && 
            board[row + direction][col - 1] != null &&
            board[row+direction][col - 1]!.isWhite != piece.isWhite){
              candidateMoves.add([row + direction, col - 1 ]);
        }
        if (isInBoard(row + direction, col + 1) && 
            board[row + direction][col+1] != null &&
            board[row+direction][col+1]!.isWhite != piece.isWhite){
              candidateMoves.add([row + direction, col + 1 ]);
        }
        break;
      case ChessPieceType.rook:
        var directions = [
          [-1,0],
          [1,0],
          [0,-1],
          [0,1],
        ];

        for (var direction in directions){
          var i = 1;
          while (true){
            var newRow = row + i*direction[0];
            var newCol = col + i*direction[1];
            if (!isInBoard(newRow, newCol)){
              break;
            }
            if (board[newRow][newCol] != null){
              if (board[newRow][newCol]!.isWhite != piece.isWhite){
                candidateMoves.add( [newRow, newCol] );
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        var knightMoves = [
          [-2,-1],
          [-2,1],
          [-1,-2],
          [-1,2],
          [1,-2],
          [1,2],
          [2,-1],
          [2,1],
        ];

        for (var move in knightMoves){
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)){
            continue;
          }
          if (board[newRow][newCol] != null){
            if (board[newRow][newCol]!.isWhite != piece.isWhite){
              candidateMoves.add( [newRow, newCol] );
            }
            continue;
          }
          candidateMoves.add( [newRow, newCol] );
        }

        break;
      case ChessPieceType.bishop:
          var directions = [
            [-1,-1],
            [-1,1],
            [1,-1],
            [1,1],
          ];
          
          for (var direction in directions){
            var i = 1;
            while (true){
              var newRow = row + i*direction[0];
              var newCol = col + i*direction[1];
              if (!isInBoard(newRow, newCol)){
                break;
              }
              if (board[newRow][newCol] != null){
                if (board[newRow][newCol]!.isWhite != piece.isWhite){
                  candidateMoves.add([newRow, newCol]);
                }
                break;
              }
              candidateMoves.add([newRow, newCol]);
              i++;
            }
          }
        break;
      case ChessPieceType.queen:
        var directions = [
          [-1,0],
          [1,0],
          [0,-1],
          [0,1],
          [-1,-1],
          [-1,1],
          [1,-1],
          [1,1],
        ];

        for (var direction in directions){
          var i = 1;
          while (true){
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)){
              break;
            }
            if (board[newRow][newCol] != null){
              if (board[newRow][newCol]!.isWhite != piece.isWhite){
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        var directions = [
          [-1,0],
          [1,0],
          [0,-1],
          [0,1],
          [-1,-1],
          [-1,1],
          [1,-1],
          [1,1],
        ];

        for (var direction in directions){
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if (!isInBoard(newRow, newCol)){
            continue;
          }
          if (board[newRow][newCol] != null){
            if (board[newRow][newCol]!.isWhite != piece.isWhite){
              candidateMoves.add([newRow, newCol]);
          }
          continue;
          }
          candidateMoves.add( [newRow, newCol] );
        }
        break;
      default:
    }
    return candidateMoves;
  }

  // Verificar que el rey no esté en jaque
  bool isKingInCheck(bool isWhiteKing){
    List<int> kingPosition = isWhiteKing ? whiteKingPosition : blackKingPosition;

    for (int i = 0; i < 8; i++){
      for (int j = 0; j < 8; j ++){
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing){
          continue;
        }
        List<List<int>> pieceValidMoves = calculateRealValidMoves(i, j, board[i][j], false);

        if (pieceValidMoves.any( (move) => move[0] == kingPosition[0] && move[1] == kingPosition[1] )){
          return true;
        }
      }
    }
    return false;
  }

  //Simular un movimiento futuro pa ver si es seguro
  bool simulatedMoveIsSafe(ChessPiece piece, int startRow, int startCol, int endRow, int endCol){
    //guardar estado actual del tablero
    ChessPiece? originalDestinationPiece = board[endRow][endCol];

    //ver si la pieza es el rey, guardar su posicion y actualizar a la nueva
    List<int>? originalKingPosition;
    if (piece.type == ChessPieceType.king){
      originalKingPosition = piece.isWhite ? whiteKingPosition : blackKingPosition;

      if (piece.isWhite){
        whiteKingPosition = [endRow, endCol];
      } else{
        blackKingPosition = [endRow, endCol];
      }
    }

    // simular el movimiento
    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    // checar si el rey esta bajo ataque
    bool kingInCheck = isKingInCheck(piece.isWhite);

    // restablecer el estado original
    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;

    // si la pieza era el rey, restablecemos
    if (piece.type == ChessPieceType.king){
      if (piece.isWhite){
        whiteKingPosition = originalKingPosition!;
      } else{
        blackKingPosition = originalKingPosition!;
      }
    }

    return !kingInCheck;
  }

  bool isCheckMate(bool isWhiteKing){
    //no jaque, no mate
    if (!isKingInCheck(isWhiteKing)){
      return false;
    }

    //si hay un movimiento legal, no es mate
    for (int i=0; i < 8; i++){
      for (int j = 0; j < 8; j ++){
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing){
          continue;
        }

        List<List<int>> pieceValidMoves = calculateRealValidMoves(i, j, board[i][j], true);

        // si la pieza tiene movimientos validos, no estamos en mate
        if (pieceValidMoves.isNotEmpty){
          return false;
        }
      }
    }

    //si no es un caso anterior, no hay movimientos legales, es mate
    return true;
  }

  // Reseteo del juego
  void resetGame(){
    Navigator.pop(context);
    _initializeBoard();
    checkStatus = false;
    whitePiecesTaken.clear();
    blackPiecesTaken.clear();
    whiteKingPosition = [7,4];
    blackKingPosition = [0,4];
    isWhiteTurn = true;
    setState( () {});
  }

  //Hacemos el tablero como widget
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [

        //capturas blancas
        /*Expanded(
          child: GridView.builder(
            itemCount: whitePiecesTaken.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8), 
          itemBuilder: (context, index) => DeadPiece(
            imagePath: whitePiecesTaken[index].imagePath,
            isWhite: true,

          ) ),
        ),*/

        //GAME STATUS
        Text(
          chessLog.value.replaceAll('_', ' '),//checkStatus ? "Check" : ""
        ),

        //Tablero:
          Expanded(
            //flex: 12,
            child: GridView.builder(
            itemCount: 8*8,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8), 
            itemBuilder: (context, index){
            
              // sacamos la fila y columna del punto
              int row = index ~/ 8;
              int col = index % 8;
            
              bool isSelected = selectedRow == row && selectedCol == col;
            
              bool isValidMove = false;
              for (var position in validMoves){
                if (position[0] == row && position[1] == col){
                  isValidMove = true;
                }
              }
            
              return Square(
                isWhite: isWhite(index),
                piece: board[row][col],
                isSelected: isSelected,
                isValidMove: isValidMove,
                onTap: () => pieceSelected(row, col),
              );
            },
                    ),
          ),
          /*Expanded(
          child: GridView.builder(
            itemCount: blackPiecesTaken.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8), 
          itemBuilder: (context, index) => DeadPiece(
            imagePath: blackPiecesTaken[index].imagePath,
            isWhite: false,

          ) ),
        ),*/
        ],
      ),
    );
  } 
}