import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<LoginInfo>> fetchLoginInfo(http.Client client) async 
{
  // Make the api call 
  // final response =
  // await client.get('https://jsonplaceholder.typicode.com/photos');
  String t = '''[{"description": "Decide what your child will eat", "token": "a token", "title": "Lunch"}, 
                    {"description": "Has your child been injured?", "token": "a token", "title": "Injuries"}]''';

  // Use the compute function to run parseLoginInfo in a separate isolate
  // Not sure why it runs in a compute function, but this calls the a function that creates a list from this result
  // return compute(parseLoginInfo, response.body);
  return compute(parseLoginInfo, t);
}

// This function converts a json into a list
List<LoginInfo> parseLoginInfo(String responseBody) 
{
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);

  return parsed.map<LoginInfo>((json) => LoginInfo.fromJson(json)).toList();
}


class LoginInfo 
{
  final String success;
  final String token;
  final String title; 
  final String description;

  LoginInfo({this.success, this.token, this.title, this.description});

  factory LoginInfo.fromJson(Map<String, dynamic> json) 
  {
    return LoginInfo(
      token: json['token'] as String,
      success: json['success'] as String,
      title: json["title"] as String,
      description: json["description"] as String
    );
  }
}

class SecondScreen extends StatelessWidget 
{
  // Pass the class a title 
  final String title;

  SecondScreen({Key key, this.title}) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return new Scaffold(
  //     appBar: new AppBar(
  //       title: new Text(title),
  //       backgroundColor: Colors.lightGreen,
  //     ),
  //     body: new Scaffold(
  //       body: new Container(
  //         // Need to dynamically create this for ever set of cards that we have 
  //         child: new Row(
  //           children: <Widget>[
  //             new Container(
  //               child: new Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: <Widget>[
  //                   // new Text(title,
  //                   //     style: new TextStyle(
  //                   //       color: Colors.lightGreen,
  //                   //     fontSize: 12.0),),
  //                 ],
  //               ),
  //             ),

  //             new Expanded(
  //               child: new Container(
  //                 // padding: new EdgeInsets.only(left: 8.0),
  //                 child: new Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 ),
  //               ),
  //             ),
 
  //             new Container(
  //               child: new Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: <Widget>[
  //                   new Text("This is the right section",
  //                       style: new TextStyle(
  //                         color: Colors.lightGreen,
  //                       fontSize: 12.0),),
  //                 ],
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //   ));
  // }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        child: FutureBuilder<List<LoginInfo>>(
          future: fetchLoginInfo(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? LoginInfoList(infoMetric: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }
}

class LoginInfoList extends StatelessWidget 
{
  // Must pass this the list that we want 
  final List<LoginInfo> infoMetric;

  LoginInfoList({Key key, this.infoMetric}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return ListView.builder(
      // This needs to be the object we pass from the api 
      itemCount: infoMetric.length,
      itemBuilder: (context, index) 
      {
        return Column(
          children: <Widget>[
            Container(
                constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.headline4.fontSize * 1.1 +
                      200.0,
                ),
                color: Colors.white10,
                alignment: Alignment.center,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Image.network(
                          infoMetric[index].token,
                          fit: BoxFit.fitWidth,
                        ),
                        title: Text(infoMetric[index].title),
                        subtitle: Text(infoMetric[index].description),
                      ),
                    ],
                  ),
                )),
          ],
        );
      },
    );
  }
}