import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ParentChildNeeds.dart';
import 'calls.dart';  


class ChildCheckNeedsScreen extends StatelessWidget
{
  // Pass the class a title 
  final String title;
  final String childId; 

  ChildCheckNeedsScreen({Key key, this.title, this.childId}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        child: FutureBuilder<List<ParentNeedsInfo>>(
          future: fetchParentNeedsInfo(http.Client(), childId),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                // ? CheckboxWidget(infoMetric: snapshot.data)
                ? CheckNeedsScreen(infoMetric: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }

}

class CheckNeedsScreen extends StatelessWidget
{
  // Pass the class a title 
  // final String title;
  final List<ParentNeedsInfo> infoMetric;
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  
  CheckNeedsScreen({Key key, this.infoMetric}) : super(key: key);

 @override
  Widget build(BuildContext context) 
  {

    return ListView.builder(

      // This needs to be the object we pass from the api 
      itemCount: infoMetric.length,
      itemBuilder: (context, index) 
      {
        String date = infoMetric[index].utcDate;
        String item = infoMetric[index].item;
        String status = infoMetric[index].status; 

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
                        Text("Item"),
                        Text("Status"),
                      ]),
                      TableRow(children: [
                        Text(date),
                        Text(item),
                        Text(status)
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