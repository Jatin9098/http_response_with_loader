import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';



void main() => runApp(new MaterialApp(
  home: new HomePage(),
)); 

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  bool _load = false;
  final String url = "https://swapi.co/api/people";
  List data = new List();

  @override
  void initState() {
    super.initState();
    this.getJsonData();
    setState((){ _load=true;});
  }

  Future<String> getJsonData() async {

    var response = await http.get(
      // Encodwe the URL
      Uri.encodeFull(url),
      // Header only accept the application/JSON file
      headers: {"Accept":"application/json"},
    );
   
    print(response.body);

    setState(() {
      print("State changed");
      _load=false;
     var convertDataTOJson = json.decode(response.body);
     data = convertDataTOJson['results'];
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
  Widget loadingIndicator =_load? new Container(
      color: Colors.grey[300],
      width: 70.0,
      height: 70.0,
      child: new Padding(padding: const EdgeInsets.all(5.0),child: new Center(child: new CircularProgressIndicator())),
    ):new Container();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Dynamic JSON load"),
      ),
      body: new Stack(
          children: <Widget>[
            new Padding( padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
            child: new ListView.builder(
                itemCount: data.length == null ? 0 : data.length,
                itemBuilder: (BuildContext context, int index){
                  return new Container(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Card(
                            child: new Container(
                              margin: const EdgeInsets.all(20.0),
                            
                              child: new Text(data[index]['name']),
                            ),
                          )
                        ],
                      ),    
                  );    
                },
              ), 
            ),
            new Align(child: loadingIndicator,alignment: FractionalOffset.center,),
          ],
      ),
      
    );
  }
}
