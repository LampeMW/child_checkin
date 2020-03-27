import 'package:child_checkin/calls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'parent_child_actions_screen.dart';
import 'ParentKidInfo.dart';     

class ParentCheckInScreen extends StatelessWidget 
{
  // Pass the class a title 
  final String title;
  final String userId; 

  ParentCheckInScreen({Key key, this.title, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        child: FutureBuilder<List<ParentKidInfo>>(
          future: fetchParentKidInfo(http.Client(), userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? CheckInInfoList(infoMetric: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }
}

class CheckInInfoList extends StatelessWidget 
{
  // Must pass this the list that we want 
  final List<ParentKidInfo> infoMetric;

  CheckInInfoList({Key key, this.infoMetric}) : super(key: key);

  switchScreens(btnName, context, childId)
  {
   // Switch the screen after selecting a class room
    String title = "Select Action";
    // SecondScreen home = new SecondScreen(title: title); 
    ParentChildActionScreen childActions = new ParentChildActionScreen(title: title, childId:childId);
    Navigator.push(context, new MaterialPageRoute(builder: (context) => childActions));

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
        String btnName = infoMetric[index].childName;
        String childId = infoMetric[index].childId; 

        final loginButon = Material(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.lightBlue[900],
          child: MaterialButton(
            color: Colors.lightBlue[900],
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed:() {
              switchScreens(btnName, context, childId);
            },
            child: Text(infoMetric[index].childName,
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
                      loginButon,
                    ],
                  ),
                )),
          ],
        );
      },
    );
  }
}