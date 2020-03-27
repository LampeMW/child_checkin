import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'calls.dart';
import 'ParentNapInfo.dart';

class ChildCheckNapScreen extends StatelessWidget
{
  // Pass the class a title 
  final String title;
  final String childId; 

  ChildCheckNapScreen({Key key, this.title, this.childId}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        child: FutureBuilder<List<ParentNapInfo>>(
          future: fetchParentNapInfo(http.Client(), childId),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                // ? CheckboxWidget(infoMetric: snapshot.data)
                ? CheckNapScreen(infoMetric: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }

}

class CheckNapScreen extends StatelessWidget
{
  // Pass the class a title 
  // final String title;
  final List<ParentNapInfo> infoMetric;
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  CheckNapScreen({Key key, this.infoMetric}) : super(key: key);

 @override
  Widget build(BuildContext context) 
  {

    return ListView.builder(

      // This needs to be the object we pass from the api 
      itemCount: infoMetric.length,
      itemBuilder: (context, index) 
      {
        String date = infoMetric[index].utcDate;
        print(date);
        String startTime = infoMetric[index].startTime;
        String endTime = infoMetric[index].endTime;

        return Column(
          children: <Widget>[
          Container(
                  color: Colors.lightBlue,
                  padding: EdgeInsets.all(20.0),
                  child: Table(
                    border: TableBorder.all(color: Colors.black),
                    children: [
                      TableRow(children: [
                        Text("Date"),
                        Text("Start Time"),
                        Text("End Time"),
                      ]),
                      TableRow(children: [
                        Text(date),
                        Text(startTime),
                        Text(endTime)
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