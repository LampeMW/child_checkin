import 'package:child_checkin/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'NapInfo.dart';
import 'calls.dart';


class ChildNapScreen extends StatefulWidget
{
  // Pass the class a title 
  final String title;
  final String classroom; 

  ChildNapScreen({Key key, this.title, this.classroom}) : super(key: key);

  @override
  ChildNapScreenState createState() => ChildNapScreenState();
}

class ChildNapScreenState extends State<ChildNapScreen> {
  String title;
  String classroom; 

  @override
  void initState() {
    super.initState();
    title = widget.title;
    classroom = widget.classroom;
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        child: FutureBuilder<List<NapInfo>>(
          future: fetchChildNapInfo(http.Client(), classroom),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                // ? CheckboxWidget(infoMetric: snapshot.data)
                ? CheckNapScreen(infoMetric: snapshot.data)
                : Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)));
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }

}

class CheckNapScreen extends StatefulWidget {
  final List<NapInfo> infoMetric;

  CheckNapScreen({Key key, this.infoMetric});

  @override
  CheckNapState createState() => CheckNapState();
}

class CheckNapState extends State<CheckNapScreen> {

  // Pass the class a title 
  // final String title;
  List<NapInfo> infoMetric;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  List<bool> isChecked = [];
  bool _loading = false;

  
  @override
  void initState() {
    super.initState();
    infoMetric = widget.infoMetric;

  }

  void switchLoadingAnimation() {
    setState(() {
      _loading = !_loading;
    });
  }


  Future<bool> submit(String startTime, String endTime, String childId) async {
    String jsonString = '''{"child_id":"$childId", "start_time":"$startTime", "end_time":"$endTime" }'''; 
    bool result = await postChildNapResults(jsonString);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _loading ? new Center(child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))) : new Container();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView.builder(
            // This needs to be the object we pass from the api 
            itemCount: infoMetric.length,
            itemBuilder: (context, index) 
            {
              final startTimeController = TextEditingController();
              final endTimeController = TextEditingController();

              String childName = infoMetric[index].childName;
              String childId = infoMetric[index].childId;
              String startTime = infoMetric[index].startTime;
              String endTime = infoMetric[index].endTime;
              // String isChecked = infoMetric[index].status; 

              final startTimeField = TextField(
                obscureText: false,
                controller: startTimeController,
                // style: style,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: startTime,
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
              );

              final endTimeField = TextField(
                obscureText: false,
                controller: endTimeController,
                // style: style,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: endTime,
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
              );

                final submitButton = Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.lightBlue[900],
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed:() async {
                      switchLoadingAnimation();
                      bool result = await submit(startTimeController.text, endTimeController.text, childId);
                      switchLoadingAnimation();
                      if (result) {
                        var _ = await showOkDialog(context, "Success");
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Submit",
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                  ),
                );
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
                          Text("Start Time"),
                          Text("End Time"),
                          Text("")
                        ]),
                        TableRow(children: [
                          Text(childName),
                          startTimeField,
                          endTimeField,
                          submitButton
                          // buildCheckbox(index),
                        ])
                      ],
                    ),
                  )
                ],
              );
            },
          ),
          new Align(child: loadingIndicator,alignment: FractionalOffset.center,),
        ]
      ),
    );
  }
}