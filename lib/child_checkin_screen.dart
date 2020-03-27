import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<List<ActionsInfo>> fetchLoginInfo(http.Client client) async 
{
  // Make the api call 
  // final response =
  // await client.get('https://jsonplaceholder.typicode.com/photos');
  String t = '''[{"description": "Decide what your child will eat", "parent_name": "Jay", "child_name": "Steven"}, 
                    {"description": "Has your child been injured?", "parent_name": "Steve", "child_name": "Gabby"},
                    {"description": "Has your child been injured?", "parent_name": "Jake", "child_name": "Joe"},
                    {"description": "Has your child been injured?", "parent_name": "Marcus", "child_name": "Matt"},
                    {"description": "Has your child been injured?", "parent_name": "Jim", "child_name": "Drew"}
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
  print(parsed);

  return parsed.map<ActionsInfo>((json) => ActionsInfo.fromJson(json)).toList();
}

class ActionsInfo 
{
  final String success;
  final String parentName;
  final String childName; 
  final String description;

  ActionsInfo({this.success, this.parentName, this.childName, this.description});

  factory ActionsInfo.fromJson(Map<String, dynamic> json) 
  {
    return ActionsInfo(
      parentName: json['parent_name'] as String,
      success: json['success'] as String,
      childName: json["child_name"] as String,
      description: json["description"] as String
    );
  }
}

// class SomeClass extends StatefulWidget{

//   State<StatefulWidget> createState(){
//     return ChildCheckinScreen(); 
//   }
// }


// class CheckboxState extends State<Checkbox> {
//   bool _checkboxChecked = false;

//   @override
//   void initState() {
//     super.initState();

//     _loadCheckboxState();
//   }

//   void checkboxChanged(bool value) {
//     setState(() {
//       _checkboxChecked = value;
//       _saveCheckboxBool(value);
//     });
//   }

//   void _saveCheckboxBool(bool value) async {
//     // SharedPreferences prefs = await SharedPreferences.getInstance();
//     // await prefs.setBool('savePassword', value);
//     String t = ""; 
//   }

//   void _loadCheckboxState() async {
//     // SharedPreferences prefs = await SharedPreferences.getInstance();
//     // bool checkboxState = prefs.getBool('savePassword');
//     setState(() {
//       _checkboxChecked = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Container(
//       padding: const EdgeInsets.only(left: 20.0, right: 0.0),
//       child: new Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           // new ColoredCheckbox(
//           //   activeColor: Colors.white,
//           //   value: _checkboxChecked, 
//           //   onChanged: (bool value) {
//           //     checkboxChanged(value);
//           //   },
//           // ),
//           new Text(
//             'Remember Password?',
//             style: new TextStyle(
//               fontSize: 12.0,
//               // color: pureWhite
//             )
//           ),
//         ],
//       )
//     );
//   }
// }



class ChildCheckinScreen extends StatelessWidget
{
  // Pass the class a title 
  final String title;

  ChildCheckinScreen({Key key, this.title}) : super(key: key);

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

  CheckInScreen({this.infoMetric});

  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  bool isChecked = false;

  bool toggleCheckbox(bool value) {
    bool checked = isChecked;
      print("it made it here");
      if(isChecked == false)
      {
        checked = true; 
      }
      else
      {
        checked = false; 
      }
      return checked; 
  }

 @override
  Widget build(BuildContext context) 
  {

    final chkBox = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff01A0C7),
          child: Checkbox(
            value: isChecked,
            onChanged: (value){toggleCheckbox(value);},
            activeColor: Colors.white,
            checkColor: Colors.black,
            tristate: false,
          )
      );

    return ListView.builder(

      // This needs to be the object we pass from the api 
      itemCount: widget.infoMetric.length,
      itemBuilder: (context, index) 
      {
        String childName = widget.infoMetric[index].childName;
        String parentName = widget.infoMetric[index].parentName;

        return Column(
          children: <Widget>[
          Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20.0),
                  child: Table(
                    border: TableBorder.all(color: Colors.black),
                    children: [
                      TableRow(children: [
                        Text("Child Name"),
                        Text("Parent Name"),
                        Text('Sign In'),
                      ]),
                      TableRow(children: [
                        Text(childName),
                        Text(parentName),
                        chkBox,
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