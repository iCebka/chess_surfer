import 'package:chess_face/log.dart';
import 'package:flutter/material.dart';
import 'book_screen.dart';
import 'explore_screen.dart';

/*
Ventana principal de la GUI
*/

String name="";

void main(){

  runApp(MyApp(),);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      title: "Chess Surfer V1",
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente los elementos de la Column
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                Image.asset("lib/assets/images/LogoFull1.png",
                width: double.infinity,
                height: 230,
                fit: BoxFit.cover,), 
                SizedBox(height: 20), // Espacio entre la imagen y los botones
                ElevatedButton( //Boton para ir a la ventana de exploracion
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExplorePage()),
                    );
              chessLog.value = ""; //Resetea el chsesLog
            }, //Estilo del boton
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              textStyle: MaterialStateProperty.all<TextStyle>(
                  TextStyle(fontFamily: 'Impact', fontSize: 16.0),//,fontWeight: FontWeight.bold),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), 
                  ),
              ),
            ),
            child: Text('Explore'),
          ),
          SizedBox(height: 30),
          ElevatedButton(//Boton para ir a la ventana de Openings
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookPage()),
              );
            },//Estilo del boton
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              textStyle: MaterialStateProperty.all<TextStyle>(
                  TextStyle(fontFamily: 'Impact', fontSize: 16.0),//,fontWeight: FontWeight.bold),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), 
                  ),
              ),
            ),
            child: Text('Openings'),
          ),
        ]),
      ),
    );
  }
}
