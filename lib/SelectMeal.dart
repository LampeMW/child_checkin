import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'teacher_select_meal_time.dart';

Future<List<MealTimeInfo>> fetchLoginInfo(http.Client client) async 
{
  // Make the api call 
  // final response =
  // await client.get('https://jsonplaceholder.typicode.com/photos');
  String t = '''[{"description": "Has your child been injured?", "token": "a token", "title": "Breakfast"},
                    {"description": "Decide what your child will eat", "token": "a token", "title": "Morning Snack"}, 
                    {"description": "Has your child been injured?", "token": "a token", "title": "Lunch"},
                    {"description": "Has your child been injured?", "token": "a token", "title": "Afternoon Snack"}
                    ]''';

  // Use the compute function to run parseLoginInfo in a separate isolate
  // Not sure why it runs in a compute function, but this calls the a function that creates a list from this result
  // return compute(parseLoginInfo, response.body);
  return compute(parseLoginInfo, t);
}

// This function converts a json into a list
List<MealTimeInfo> parseLoginInfo(String responseBody) 
{
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<MealTimeInfo>((json) => MealTimeInfo.fromJson(json)).toList();
}


class MealTimeInfo 
{
  final String success;
  final String token;
  final String title; 
  final String description;

  MealTimeInfo({this.success, this.token, this.title, this.description});

  factory MealTimeInfo.fromJson(Map<String, dynamic> json) 
  {
    return MealTimeInfo(
      token: json['token'] as String,
      success: json['success'] as String,
      title: json["title"] as String,
      description: json["description"] as String
    );
  }
}

class CheckMealScreen extends StatelessWidget 
{
  // Pass the class a title 
  final String title;
  final String classroom; 
  final String userId; 

  CheckMealScreen({Key key, this.title, this.classroom, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: 
       Padding(
        child: FutureBuilder<List<MealTimeInfo>>(
          future: fetchLoginInfo(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? CheckMealInfoList(infoMetric: snapshot.data, userId: userId, classroom: classroom)
                : Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)));
          },
        ),

        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }
}

class CheckMealInfoList extends StatefulWidget {
  final List<MealTimeInfo> infoMetric;
  final String userId; 
  final String classroom; 

  CheckMealInfoList({this.infoMetric, this.userId, this.classroom});
  @override
  _CheckMealInfoListState createState() => _CheckMealInfoListState();
}

class _CheckMealInfoListState extends State<CheckMealInfoList> {
  bool _loading = false;

  switchScreens(btnName, context, classroom) {
   // Switch the screen after selecting a class room
    String title = "How much did they eat?";
    // SecondScreen home = new SecondScreen(title: title); 
    ChildMealScreen childMeals = new ChildMealScreen(title: title, mealTime: btnName, classroom:classroom);
    Navigator.push(context, new MaterialPageRoute(builder: (context) => childMeals));
  }

  void switchLoadingAnimation() {
    setState(() {
      _loading = !_loading;
    });
  }


  @override
  Widget build(BuildContext context) 
  {
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
        itemCount: widget.infoMetric.length,
        itemBuilder: (context, index) 
        {
          String btnName = widget.infoMetric[index].title;        

          final loginButon = Material(
            color: Colors.lightBlue[900],
            elevation: 5.0,
            borderRadius: BorderRadius.circular(30.0),

            child: MaterialButton(
              color: Colors.lightBlue[900],
              clipBehavior: Clip.antiAlias,
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed:() {
                switchScreens(btnName, context, widget.classroom);
              },
              child: Text(widget.infoMetric[index].title,
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
                  // color: Colors.white10,
                  color: Colors.lightBlue,
                  alignment: Alignment.center,
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // ListTile(
                        //   leading: Image.asset('assets/images/Kids_Day_Care.jpg',

                        //   ),
                        //   title: Text(infoMetric[index].title),
                        //   subtitle: Text(infoMetric[index].description),
                        // ),
                        loginButon,
                      ],
                    ),
                  )),
            ],
          );
        },
      )
        ]
      ),
    );
  }
}