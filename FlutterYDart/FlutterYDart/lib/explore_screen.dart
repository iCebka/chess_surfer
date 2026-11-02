// ignore_for_file: must_be_immutable

/*
Ventana de exploracion y metodos de la APi usados en ella
*/

import 'package:chess_face/log.dart';
import 'package:flutter/material.dart';
import 'board_stuff/game_board.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


Future<List<String>>? variants; //Usado para desplegar variantes en pantalla

// Recibe el log de jugadas como argumento y devuelve la informacion de la apertura que devuelve buscarlinea en la API
  Future<String> buscarLinea(String logo) async{
    var url = Uri.parse('http://localhost:8080/buscarlinea?log=$logo');
    var response = await http.get(url);
    String pos = "";
    if (response.statusCode == 200){
      var bodyUtf8 = utf8.decode(response.bodyBytes);
      //print(logo);
      if (bodyUtf8 != ""){
        pos = response.body;
      }
      return pos;
    }
    else{
      throw Exception("No se pudo conectar a la API");
    }
  }

  // Da como argumento el log de jugadas y devuelve una lista de strings con la informacion de las variantes de la apertura
  // de ese log de jugadas usando la funcion variantes de la API
  Future<List<String>> _lookFor(String logo) async{
    var url = Uri.parse('http://localhost:8080/variantes?log=$logo');
    var response = await http.get(url);
    List<String>vars = [];
    if (response.statusCode == 200){
      var bodyUtf8 = utf8.decode(response.bodyBytes);
      //print(logo);
      if (bodyUtf8 != ""){
        List<dynamic> variantes = jsonDecode(bodyUtf8);
        for (var variante in variantes){
          //print('${variante['name']} - ${variante['log']}');
          vars.add ( ('${variante['eco']} - ${variante['name']} / ${variante['log']}'));
        }
      }
      return vars;
    }
    else{
      throw Exception("No se pudo conectar a la API");
    }
  }

class ExplorePage extends StatelessWidget {

  ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: ExploreScreen(),
    );
  }
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ExploreScreenState();
}

class ExploreScreenState extends State<ExploreScreen> {

  //Reiniciamos la log cada vez que se abre esta ventana
  @override
  void initState() {
    super.initState();
    chessLog.value = "";
  }

  @override
  Widget build(BuildContext context) {
  return Stack(
    children: [
      Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Alineación cruzada centrada
            children: [
               Image.asset(
                'lib/assets/images/LogoNoSlogan.png',
                height: 50,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Exploration',
                  style: TextStyle(fontFamily: 'Impact', fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
              child: ValueListenableBuilder<String>(//Este widget se actualiza cada vez que se cambie el contenido de la log (cada vez que se hace una jugada)
                  valueListenable: chessLog, 
                  builder: (context, value, child) {
                  return FutureBuilder( //Se usa FutureBuilder para poder hacer GUI con informacion de metodos asincronos como los de la API
                      future: buscarLinea(chessLog.value),
                      builder: (context, snapshot){//snapshot es el contenido de chessLog
                        if (snapshot.hasData){
                          //print(snapshot.data);
                          return Text(snapshot.data.toString());
                        }
                        else if (snapshot.hasError){
                          //print(snapshot.error);
                          return Text("Error");
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    );
                  }
              ),
              ),
             
              const SizedBox(
                width: 300, // Ancho total del tablero
                height: 340, // Altura del tablero
                child: GameBoard(), //Aqui va el tablero
              ),
              //SizedBox(height: 5.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Openings',
                  style: TextStyle(fontFamily: 'Impact', fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ), // Espacio entre el TextField y la lista
              Expanded(
                child: ValueListenableBuilder<String>(//Cada vez que se cambia la log, se actualiza la lista de aperturas recomendadas
                  valueListenable: chessLog,
                  builder: (context, value, child) {
                    return FutureBuilder(//Tambien con FutureBuilder porque se usa operaciones de la API
                      future: _lookFor(value),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          List<dynamic> variants = snapshot.data as List<dynamic>;
                          return ListView.builder(
                            itemCount: variants.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(//Las aperturas se presentan como ListTile
                                  leading: Image.asset(index%2 == 0 ? 'lib/assets/images/blueboard.png' : 'lib/assets/images/Clean2.png'),
                                  title: Text(variants[index].substring(0,variants[index].indexOf('/'))),
                                  trailing: IconButton(
                                    icon: Icon(Icons.arrow_forward),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(//Ventana de previsualización de apertura
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [Align(
                                                      alignment: Alignment.topRight,
                                                      child: IconButton(
                                                        icon: Icon(Icons.close),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ),
                                                Text(variants[index].substring(0,variants[index].indexOf('/'))),
                                                SizedBox(height: 8.0),
                                                Image.asset(index%2 == 0 ? 'lib/assets/images/blueboard.png' : 'lib/assets/images/Clean2.png'),
                                                //Text(variants[index]['log']),
                                                SizedBox(height: 8.0),
                                                Text(variants[index].substring(variants[index].indexOf('/')+1)),
                                                ElevatedButton(//Boton Review
                                                  onPressed: () {
                                                    // Acción al presionar el botón 'Review'
                                                     Navigator.of(context).pop();
                                                  },
                                                  style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                        textStyle: MaterialStateProperty.all<TextStyle>(
                                                            TextStyle(fontFamily: 'Impact', fontSize: 16.0,fontWeight: FontWeight.bold),
                                                        ),
                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10.0), 
                                                            ),
                                                        ),
                                                      ),
                                                  child: Text('Review'),
                                                ),
                                              ],
                                            ),
                                            
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
}