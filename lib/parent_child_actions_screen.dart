import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import 'child_checkin_screen.dart';
// import 'child_checkout_screen.dart';

// Move these imports to an approiate class when it is created
import 'parent_child_bathroom.dart';
import 'parent_child_slept.dart';
import 'parent_child_needs.dart';
import 'parent_child_ate.dart';

Future<List<ActionsInfo>> fetchLoginInfo(http.Client client) async 
{
  // Make the api call 
  // final response =
  // await client.get('https://jsonplaceholder.typicode.com/photos');
  String t = '''[{"description": "Decide what your child will eat", "token": "a token", "title": "I Ate"}, 
                    {"description": "Has your child been injured?", "token": "a token", "title": "I Need"},
                    {"description": "Has your child been injured?", "token": "a token", "title": "I Went"},
                    {"description": "Has your child been injured?", "token": "a token", "title": "I Slept"}
                    ]''';
  print(t);
  // Use the compute function to run parseLoginInfo in a separate isolate
  // Not sure why it runs in a compute function, but this calls the a function that creates a list from this result
  // return compute(parseLoginInfo, response.body);
  return compute(parseLoginInfo, t);
}

// This function converts a json into a list
List<ActionsInfo> parseLoginInfo(String responseBody) 
{
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);

  return parsed.map<ActionsInfo>((json) => ActionsInfo.fromJson(json)).toList();
}

class ActionsInfo 
{
  final String token;
  final String title; 
  final String description;

  ActionsInfo({this.token, this.title, this.description});

  factory ActionsInfo.fromJson(Map<String, dynamic> json) 
  {
    return ActionsInfo(
      token: json['token'] as String,
      title: json["title"] as String,
      description: json["description"] as String
    );
  }
}

class ParentChildActionScreen extends StatelessWidget 
{
  // Pass the class a title 
  final String title;
  final String childId; 

  ParentChildActionScreen({Key key, this.title, this.childId}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        child: FutureBuilder<List<ActionsInfo>>(
          future: fetchLoginInfo(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? ChildActionInfoList(infoMetric: snapshot.data, childId: childId)
                : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }
}

class ChildActionInfoList extends StatelessWidget 
{
  // Must pass this the list that we want 
  final List<ActionsInfo> infoMetric;
  final String childId; 

  ChildActionInfoList({Key key, this.infoMetric, this.childId}) : super(key: key);

  switchScreens(btnName, context, childId)
  {
   // Switch the screen after the user has been authenticated properly
    bool loginStatus = true; 
    if (loginStatus == true)
    {
      print(btnName);
      print(childId);
      if(btnName == 'I Ate')
      {
          String title = "I Ate";
          // SecondScreen home = new SecondScreen(title: title); 

          // ChildCheckinScreen checkin = new ChildCheckinScreen(title: title);
          ChildCheckFoodScreen checkin = new ChildCheckFoodScreen(title: title, childId: childId);
          Navigator.push(context, new MaterialPageRoute(builder: (context) => checkin));
      }
      else if(btnName == 'I Need')
      {
          String title = "I Need";
          // SecondScreen home = new SecondScreen(title: title); 
          ChildCheckNeedsScreen checkout = new ChildCheckNeedsScreen(title: title, childId: childId);
          Navigator.push(context, new MaterialPageRoute(builder: (context) => checkout));
      }
      else if(btnName == 'I Slept')
      {
          String title = "I Slept";
          // SecondScreen home = new SecondScreen(title: title); 
          ChildCheckNapScreen checkout = new ChildCheckNapScreen(title: title, childId: childId);
          Navigator.push(context, new MaterialPageRoute(builder: (context) => checkout));
      }
      else if(btnName == 'I Went')
      {
          String title = "I Went";
          // SecondScreen home = new SecondScreen(title: title); 
          ChildCheckBathroomScreen checkout = new ChildCheckBathroomScreen(title: title, childId: childId);
          Navigator.push(context, new MaterialPageRoute(builder: (context) => checkout));
      }

    }
  }

  @override
  Widget build(BuildContext context) 
  {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    return ListView.builder(

      // This needs to be the object we pass from the api 
      itemCount: infoMetric.length,
      itemBuilder: (context, index) 
      {
        String btnName = infoMetric[index].title;

        final loginButton = Material(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.lightBlue[900],
          child: MaterialButton(
            color: Colors.lightBlue[900],
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed:() {
              switchScreens(btnName, context, childId);
            },
            child: Text(infoMetric[index].title,
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
      );

        return Column(
          children: <Widget>[
            Container(
                constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.headline4.fontSize * 1.1 +
                      50.0,
                ),
                color: Colors.lightBlue,
                alignment: Alignment.center,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      loginButton,
                    ],
                  ),
                )),
          ],
        );
      },
    );
  }
}