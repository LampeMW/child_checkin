import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ChildCheckinScreen.dart';
import 'teacher_nap_time.dart'; 
import 'SelectMeal.dart';
import 'teacher_input_bathroom.dart';
import 'teacher_input_mood.dart';
import 'teacher_input_supplies.dart';

Future<List<ActionsInfo>> fetchLoginInfo(http.Client client, String classroom) async 
{
  // Make the api call 
  // final response =
  // await client.get('https://jsonplaceholder.typicode.com/photos');
  String t = '''[{"description": "Decide what your child will eat", "token": "a token", "title": "Check In or Check Out", "classroom":"$classroom"}, 
                    {"description": "Has your child been injured?", "token": "a token", "title": "Nap Time", "classroom":"$classroom"},
                    {"description": "Has your child been injured?", "token": "a token", "title": "Diaper Change", "classroom":"$classroom"},
                    {"description": "Has your child been injured?", "token": "a token", "title": "Mood", "classroom":"$classroom"},
                    {"description": "Has your child been injured?", "token": "a token", "title": "Meals", "classroom":"$classroom"},
                    {"description": "Has your child been injured?", "token": "a token", "title": "Supplies", "classroom":"$classroom"}
                    ]''';

  // Use the compute function to run parseLoginInfo in a separate isolate
  // Not sure why it runs in a compute function, but this calls the a function that creates a list from this result
  // return compute(parseLoginInfo, response.body);
  return compute(parseLoginInfo, t);
}

// This function converts a json into a list
List<ActionsInfo> parseLoginInfo(String responseBody) 
{
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<ActionsInfo>((json) => ActionsInfo.fromJson(json)).toList();
}

class ActionsInfo 
{
  final String success;
  final String token;
  final String title; 
  final String description;
  final String classroom;

  ActionsInfo({this.success, this.token, this.title, this.description, this.classroom});

  factory ActionsInfo.fromJson(Map<String, dynamic> json) 
  {
    return ActionsInfo(
      token: json['token'] as String,
      success: json['success'] as String,
      title: json["title"] as String,
      description: json["description"] as String,
      classroom: json["classroom"] as String
    );
  }
}

class ChildActionScreen extends StatelessWidget 
{
  // Pass the class a title 
  final String title;
  final String classroom; 

  ChildActionScreen({Key key, this.title, this.classroom}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        child: FutureBuilder<List<ActionsInfo>>(
          future: fetchLoginInfo(http.Client(), this.classroom),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? ChildActionInfoList(infoMetric: snapshot.data)
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

  ChildActionInfoList({Key key, this.infoMetric}) : super(key: key);

  switchScreens(btnName, context, classroom)
  {
   // Switch the screen after the user has been authenticated properly
    bool loginStatus = true; 
    if (loginStatus == true)
    {
      if(btnName == 'Check In or Check Out')
      {
          String title = "Student Check In Control";
          ChildCheckinScreen checkin = new ChildCheckinScreen(title: title, classroom: classroom);
          Navigator.push(context, new MaterialPageRoute(builder: (context) => checkin));
      }
      else if(btnName == 'Nap Time')
      {
          String title = "Student Naps";
          ChildNapScreen napTime = new ChildNapScreen(title: title);
          Navigator.push(context, new MaterialPageRoute(builder: (context) => napTime));
      }
      else if(btnName == "Meals")
      {
          String title = "Select Meal Time";
          CheckMealScreen mealTime = new CheckMealScreen(title: title);
          Navigator.push(context, new MaterialPageRoute(builder: (context) => mealTime));
      }
      else if (btnName == "Diaper Change")
      {
          String title = "Student Bathroom Breaks";
          ChildBathroomScreen bathroomBreaks = new ChildBathroomScreen(title: title, classroom: classroom);
          Navigator.push(context, new MaterialPageRoute(builder: (context) => bathroomBreaks));
      }
      else if (btnName == "Mood")
      {
          String title = "Student Moods";
          ChildMoodScreen mood = new ChildMoodScreen(title: title, classroom: classroom);
          Navigator.push(context, new MaterialPageRoute(builder: (context) => mood));
      }
      else if (btnName == "Supplies")
      {
          String title = "Student Supplies";
          ChildSuppliesScreen supplies = new ChildSuppliesScreen(title: title, classroom: classroom);
          Navigator.push(context, new MaterialPageRoute(builder: (context) => supplies));
      }
      

    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 200.0,
            child: Image.asset('assets/images/Kids_Day_Care.jpg',
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            // This needs to be the object we pass from the api 
            itemCount: infoMetric.length,
            itemBuilder: (context, index) 
            {
              String btnName = infoMetric[index].title;
              String classroom = infoMetric[index].classroom; 
              final loginButton = Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                // color: Color(0xff01A0C7),
                color: Colors.lightBlue[900],
                child: MaterialButton(
                  color: Colors.lightBlue[900],
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed:() {
                    switchScreens(btnName, context, classroom);
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
          ),
        ],
      )
    );
  }
}