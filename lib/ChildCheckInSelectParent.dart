import 'dart:convert';
import 'package:child_checkin/ParentInfo.dart';
import 'package:child_checkin/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ParentInfo.dart';
import 'calls.dart';


class ChildParentScreen extends StatefulWidget
{
  // Pass the class a title 
  final String title;
  final String childId; 
  final String jsonString; 

  ChildParentScreen({Key key, this.title, this.childId, this.jsonString}) : super(key: key);

  @override
  ChildCheckParentScreenState createState() => ChildCheckParentScreenState();
}

class ChildCheckParentScreenState extends State<ChildParentScreen> {
  String title;
  String childId; 
  String jsonString; 

  @override
  void initState() {
    super.initState();
    title = widget.title;
    childId = widget.childId; 
    jsonString = widget.jsonString;
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        child: FutureBuilder<List<ParentInfo>>(
          future: fetchParentInfo(http.Client(), childId),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                // ? CheckboxWidget(infoMetric: snapshot.data)
                ? CheckParentScreen(infoMetric: snapshot.data, jsonString:jsonString)
                : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }

}

class CheckParentScreen extends StatefulWidget {
  final List<ParentInfo> infoMetric;
  final String jsonString; 

  CheckParentScreen({Key key, this.infoMetric, this.jsonString});

  @override
  CheckParentScreenState createState() => CheckParentScreenState();

}

class CheckParentScreenState extends State<CheckParentScreen> {

  // Pass the class a title 
  List<ParentInfo> infoMetric;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  List<bool> isChecked = [];
  String jsonString; 

  @override
  void initState() {
    super.initState();
    infoMetric = widget.infoMetric;
    jsonString = widget.jsonString; 
    for (var i = 0; i < infoMetric.length; i++) 
    {
      isChecked.add(false);
    }
  }

  Future<bool> buildSubmitRequest(bool value, int index, String jsonString, String userId, String userName, String signInStatus) async {
    bool checkedStatus = isChecked[index];
    Map modJsonString = json.decode(jsonString);
    modJsonString["user_id"] = userId;
    modJsonString["user_name"] = userName; 
    modJsonString["sign_in_status"] = checkedStatus; 
    modJsonString.remove("signInStatus");
    String updatedJsonString = json.encode(modJsonString);

    // Submit the data to the api 
    print(modJsonString);
    bool result = await postchildCheckinResults(updatedJsonString);
    return result;

  }

  void toggleCheckbox(bool value, int index, String childId, String userId, String userName, String signInStatus) async {
      setState(() {
        isChecked[index] = !isChecked[index];
      });
      String signInStatus = 'Y'; 

      if(isChecked[index] == false)
      {
          signInStatus = 'N'; 
      }
      bool result = await buildSubmitRequest(value, index, childId, userId, userName, signInStatus);
      if (result) {
        var _ = await showOkDialog(context, "Success");
        Navigator.pop(context);
      }
      // return isChecked[index]; 
  }

  Widget buildCheckbox(int index, String childId, String userId, String userName, String signInStatus) {
    return Material(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.lightBlue,
          child: Checkbox(
            value: isChecked[index],
            onChanged: (value){toggleCheckbox(value, index, childId, userId, userName, signInStatus);},
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
          Map decodedJson = json.decode(jsonString);
          String childName = decodedJson["child_name"]; 
          String checkInAction = decodedJson["signInStatus"];
          String userName = infoMetric[index].userName;
          String userId = infoMetric[index].userId; 
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
                          Text("Parent Name"),
                          Text('Parent Responsible'),
                        ]),
                        TableRow(children: [
                          Text(childName),
                          Text(userName),
                          buildCheckbox(index, jsonString, userId, userName, checkInAction),
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