import 'package:chess_face/explore_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/*
Pantalla de Repertorio de aperturas
*/

class BookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text('Third Window'),
      ),
      body: BookScreen(),
    );
  }
}

class BookScreen extends StatefulWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BookScreenState();
}

//Metodo de busqueda de la API
 Future<List<String>> _search() async{
    var url = Uri.parse('http://localhost:8080/aperturas');
    var response = await http.get(url);
    List<String> ops = [];

    if (response.statusCode == 200){
      var bodyUtf8 = utf8.decode(response.bodyBytes);
      //print(bodyUtf8);
      if (bodyUtf8 != ""){
        List<dynamic>opes = jsonDecode(bodyUtf8);
        for (var op in opes){
          //print('${op["eco"]} : ${op["name"]}');
          ops.add ( ('${op['eco']} : ${op['name']}/${op['log']}'));
        }
      }
      return ops;
    }
    else{
      throw Exception("No se pudo conectar a la API");
    }
  }

class BookScreenState extends State<BookScreen> {
  bool isChecked = false;
  Future<List<String>> openings = _search();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets/images/LogoNoSlogan.png',
                  height: 180,
                ),
                Text(
                  'Opening book',
                  style: TextStyle(fontFamily: 'Impact', fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: Container(
                    color: Colors.lightBlue[100],
                    child: FutureBuilder( //Future Builder porque trabajamos con la funcion asincrona que invoca a la API
                      future: openings = _search(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          List<dynamic> openings = snapshot.data as List<dynamic>;
                          return ListView.builder(
                            itemCount: openings.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile( // Las aperturas se despliegan como ListTile
                                  leading: Image.asset(index%2 == 0 ? 'lib/assets/images/blueboard.png' : 'lib/assets/images/Clean2.png'),
                                  title: Text(openings[index].substring(0,openings[index].indexOf('/'))), //Extraemos solo la parte del nombre de la string retornada por el metodo _search
                                  trailing: IconButton(
                                    icon: Icon(Icons.arrow_forward),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
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
                                                Text(openings[index].substring(0,openings[index].indexOf('/'))),
                                                SizedBox(height: 8.0),
                                                Image.asset(index%2 == 0 ? 'lib/assets/images/blueboard.png' : 'lib/assets/images/Clean2.png'),
                                                //Text(variants[index]['log']),
                                                SizedBox(height: 8.0),
                                                Text(openings[index].substring(openings[index].indexOf('/')+1)),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => ExplorePage()),
                                                    );
                                                  },
                                                  style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                        textStyle: MaterialStateProperty.all<TextStyle>(
                                                            TextStyle(fontFamily: 'Impact', fontSize: 16.0,fontWeight: FontWeight.bold),
                                                        ),
                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10.0), // Ajusta el valor según desees
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
                    ),
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