import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ActionsInfo.dart';
import 'calls.dart';
import 'ChildCheckInSelectParent.dart';



class ChildCheckinScreen extends StatefulWidget
{
  // Pass the class a title 
  final String title;
  final String classroom; 

  ChildCheckinScreen({Key key, this.title, this.classroom}) : super(key: key);

  @override
  ChildCheckinScreenState createState() => ChildCheckinScreenState();
}

class ChildCheckinScreenState extends State<ChildCheckinScreen> {
  String title;
  String childRoom; 

  @override
  void initState() {
    super.initState();
    title = widget.title;
    childRoom = widget.classroom; 
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        child: FutureBuilder<List<ActionsInfo>>(
          future: fetchChildRoomInfo(http.Client(), childRoom),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                // ? CheckboxWidget(infoMetric: snapshot.data)
                ? CheckInScreen(infoMetric: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }

}

class CheckInScreen extends StatefulWidget {
  final List<ActionsInfo> infoMetric;

  CheckInScreen({Key key, this.infoMetric});

  @override
  CheckInScreenState createState() => CheckInScreenState();

}

class CheckInScreenState extends State<CheckInScreen> {

  // Pass the class a title 
  List<ActionsInfo> infoMetric;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  List<bool> isChecked = [];

  @override
  void initState() {
    super.initState();
    infoMetric = widget.infoMetric;

    for (var i = 0; i < infoMetric.length; i++) 
    {
      String checkedStatus = infoMetric[i].checkedIn;
      if(checkedStatus == "N")
      {
        isChecked.add(false);
      }
      else
      {
        isChecked.add(true); 
      }
    }
  }


  void buildSubmitRequest(bool value, int index, String childId, String childName)
  {
    bool checkedStatus = isChecked[index];
    print(value);
    String jsonString = '''{"child_id":"$childId", "signInStatus":"$checkedStatus", "child_name":"$childName" }''';
    print(jsonString);

    String title = "Select Parent Responsible";
    ChildParentScreen childMeals = new ChildParentScreen(title: title, jsonString: jsonString, childId: childId);
    Navigator.push(context, new MaterialPageRoute(builder: (context) => childMeals));

  }

  bool toggleCheckbox(bool value, int index, String childId, String childName) {
      setState(() {
        isChecked[index] = !isChecked[index];
      });
      String signInStatus = 'Y'; 

      if(isChecked[index] == false)
      {
          signInStatus = 'N'; 
      }
      buildSubmitRequest(value, index, childId, childName);
      //postSigninResults(childId, signInStatus);
      return isChecked[index]; 
  }

  Widget buildCheckbox(int index, String childId, String childName) {
    print(isChecked[index]);
    return Material(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.lightBlue,
          child: Checkbox(
            value: isChecked[index],
            onChanged: (value){toggleCheckbox(value, index, childId, childName);},
            activeColor: Colors.lightBlue,
            checkColor: Colors.black,
            tristate: false,
          )
      );
  }

 @override
  Widget build(BuildContext context) 
  {

    return Scaffold(
      body: ListView.builder(
        // This needs to be the object we pass from the api 
        itemCount: infoMetric.length,
        itemBuilder: (context, index) 
        {
          String childName = infoMetric[index].childName;
          String childId = infoMetric[index].childId;

          return Column(
            children: <Widget>[
            Container(
                    color: Colors.lightBlue,
                    padding: EdgeInsets.all(20.0),
                    child: Table(
                      border: TableBorder.all(color: Colors.black),
                      children: [
                        TableRow(children: [
                          Text("Child Name"),
                          Text('Signed In Status'),
                        ]),
                        TableRow(children: [
                          Text(childName),
                          buildCheckbox(index, childId, childName),
                        ])
                      ],
                    ),
                  )
            ],
          );
        },
      ),
    );
  }
}