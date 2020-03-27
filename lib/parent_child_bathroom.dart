import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'calls.dart';
import 'ParentBathroomInfo.dart'; 


class ChildCheckBathroomScreen extends StatelessWidget
{
  // Pass the class a title 
  final String title;
  final String childId; 

  ChildCheckBathroomScreen({Key key, this.title, this.childId}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        child: FutureBuilder<List<ParentBathroomInfo>>(
          future: fetchParentBathroomInfo(http.Client(), childId),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? CheckBathroomScreen(infoMetric: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }

}

class CheckBathroomScreen extends StatefulWidget {
  final List<ParentBathroomInfo> infoMetric;

  CheckBathroomScreen({this.infoMetric});

  @override
  _CheckBathroomScreenState createState() => _CheckBathroomScreenState();
}

class _CheckBathroomScreenState extends State<CheckBathroomScreen> {
  bool isChecked = false;
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  
  @override
  void initState() {
    super.initState();
  }

  bool toggleCheckbox(bool value) {
      print("it made it here");
      if(isChecked == false)
      {
        isChecked = true; 
      }
      else
      {
        isChecked = false; 
      }
      return isChecked; 
  }

 @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // This needs to be the object we pass from the api 
      itemCount: widget.infoMetric.length,
      itemBuilder: (context, index) 
      { 
        String date = widget.infoMetric[index].utcDate; 
        String type = widget.infoMetric[index].type; 

        return Column(
          children: <Widget>[
          Container(
                  color: Colors.lightBlue,
                  padding: EdgeInsets.all(20.0),
                  child: Table(
                    border: TableBorder.all(color: Colors.black),
                    children: [
                      TableRow(children: [
                        Text("Type"),
                        Text("  "),
                        Text("Time"),
                      ]),
                      TableRow(children: [
                        Text(type),
                        Text("At"),
                        Text(date)
                      ])
                    ],
                  ),
                )
          ],
        );
      },
    );
  }
}