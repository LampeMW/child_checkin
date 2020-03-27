import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'admin_add_child.dart'; 

Future<List<CheckInInfo>> fetchLoginInfo(http.Client client) async 
{
  // Make the api call 
  // final response =
  // await client.get('https://jsonplaceholder.typicode.com/photos');
  String t = '''[{"description": "Decide what your child will eat", "token": "a token", "title": "Add Child"}, 
                    {"description": "Has your child been injured?", "token": "a token", "title": "View Children"}
                    ]''';

  // Use the compute function to run parseLoginInfo in a separate isolate
  // Not sure why it runs in a compute function, but this calls the a function that creates a list from this result
  // return compute(parseLoginInfo, response.body);
  return compute(parseLoginInfo, t);
}

// This function converts a json into a list
List<CheckInInfo> parseLoginInfo(String responseBody) 
{
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<CheckInInfo>((json) => CheckInInfo.fromJson(json)).toList();
}


class CheckInInfo 
{
  final String success;
  final String token;
  final String title; 
  final String description;

  CheckInInfo({this.success, this.token, this.title, this.description});

  factory CheckInInfo.fromJson(Map<String, dynamic> json) 
  {
    return CheckInInfo(
      token: json['token'] as String,
      success: json['success'] as String,
      title: json["title"] as String,
      description: json["description"] as String
    );
  }
}

class SelectAdminScreen extends StatelessWidget 
{
  // Pass the class a title 
  final String title;
  final String classroom; 
  final String userId; 

  SelectAdminScreen({Key key, this.title, this.classroom, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: 
       Padding(
        child: FutureBuilder<List<CheckInInfo>>(
          future: fetchLoginInfo(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? SelectAdminList(infoMetric: snapshot.data, userId: userId)
                : Center(child: CircularProgressIndicator());
          },
        ),

        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }
}

class SelectAdminList extends StatelessWidget 
{
  // Must pass this the list that we want 
  final List<CheckInInfo> infoMetric;
  final String userId; 

  SelectAdminList({Key key, this.infoMetric, this.userId}) : super(key: key);

  switchScreens(btnName, context)
  {
   // Switch the screen after selecting a class room
    String title = "Select Action";
    String classroom = btnName;
    // SecondScreen home = new SecondScreen(title: title); 
    if(classroom == "Add Child")
    {
      AddKidScreen addKid = new AddKidScreen(title: title, classroom: btnName, userId:userId );
      Navigator.push(context, new MaterialPageRoute(builder: (context) => addKid));
    }
    else
    {
      AddKidScreen addKid = new AddKidScreen(title: title, classroom: btnName, userId:userId );
      Navigator.push(context, new MaterialPageRoute(builder: (context) => addKid));
    }


  }

  @override
  Widget build(BuildContext context) 
  {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    return Column(
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
              switchScreens(btnName, context);
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
      );
  }
}