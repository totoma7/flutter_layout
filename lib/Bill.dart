import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Bill  extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomeScreenState();

}

class Picture{
  /*
  "email": "ilchul.jung@naver.com",
        "name": "sample1",
        "userId": "af42ebfb-a263-4c0d-be07-9a62daf8d48d"
 */

  String name;
  String id;
  String filename;
  String filecontent;
  String filebyte;

  Picture(this.name,this.id,this.filename,this.filecontent,this.filebyte);

}


class _HomeScreenState  extends State<Bill>{
  List _data = [];
  int page =1;
  int limit = 20;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
  // String tokenString ="eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI3NzJmNzc3Mi0wN2Q4LTRhMGMtODQ5NC05NTMyYWRiZGIxMTIiLCJleHAiOjE2MzE3MDY0NjV9.A7-1CZX_M1bNUhgtM2S4rcBrqCXufwz1O9uLGkqkw1Uabueoqvn4aVzs26KKcgqOhKMHTu3s9k_GnHVJeZZa6g";
  _fetchData() async {
    print('test');

    final response = await http.get(
      Uri.parse('http://222.108.225.7:18080/test/data'),
      // Send authorization headers to the backend.

    );

    print('success');
    if(response.statusCode == 200){
      // String jsonString = response.body;
      var responseBody = utf8.decode(response.bodyBytes);
      print(responseBody);

      List pictures = jsonDecode(responseBody);

      for(int i =0;i<pictures.length;i++){
        var picture = pictures[i];
        Picture pictureToAdd = Picture(picture["name"],picture["id"],picture["filename"],picture["filecontent"],picture["filebyte"] );
        print(pictureToAdd.filename);
        setState(() {
          _data.add(pictureToAdd);
          page++;
        });
      }


    }else{
      print('error');
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text('지출 내역'),
        actions: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: (){
                _fetchData();
              }, icon:
              Icon(Icons.add),
              tooltip: '더가져오기',
              iconSize: 30,),
            ],
          )
        ],
      ),
      body: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (context ,index ) {
            Picture picture = _data[index];
            return Card(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        child: Image.memory(base64Decode(picture.filebyte),width: 130,height: 130,),
                       onPressed:(){
                         showDialog(
                         context: context,
                         builder: (BuildContext context){
                          return AlertDialog(
                            contentPadding:  EdgeInsets.all(10.0),
                            titlePadding:  EdgeInsets.all(0.0),
                            buttonPadding: EdgeInsets.all(0.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                            ),
                           content: Image.memory(base64Decode(picture.filebyte),width: 400,height: 400,),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("Close"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                         },
                         );
                        },
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(picture.id),
                          Text(picture.filename),
                      ]
                      )

                    ]
                )
            );
          }),
    );
  }

}