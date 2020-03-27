import 'package:child_checkin/MoodInfo.dart';
import 'package:child_checkin/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'MoodInfo.dart';
import 'calls.dart';


class ChildMoodScreen extends StatefulWidget
{
  // Pass the class a title 
  final String title;
  final String classroom; 

  ChildMoodScreen({Key key, this.title, this.classroom}) : super(key: key);

  @override
  ChildCheckMoodState createState() => ChildCheckMoodState();
}

class ChildCheckMoodState extends State<ChildMoodScreen> {
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
        child: FutureBuilder<List<MoodInfo>>(
          future: fetchChildMoodInfo(http.Client(), classroom),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                // ? CheckboxWidget(infoMetric: snapshot.data)
                ? CheckMoodScreen(infoMetric: snapshot.data)
                : Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)));
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }

}

class CheckMoodScreen extends StatefulWidget {
  final List<MoodInfo> infoMetric;

  CheckMoodScreen({Key key, this.infoMetric});

  @override
  CheckMoodState createState() => CheckMoodState();

}

class CheckMoodState extends State<CheckMoodScreen> {

  // Pass the class a title 
  // final String title;
  List<MoodInfo> infoMetric;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  List<bool> sleepyChecked = [];
  List<bool> hyperChecked = [];
  List<bool> happyChecked = []; 
  List<bool> crankyChecked = []; 
  List<bool> grumpyChecked = []; 
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    infoMetric = widget.infoMetric;

    // Make api call here 
    for (var i = 0; i < infoMetric.length; i++) 
    {
      String sleepyStr = infoMetric[i].sleepy;
      String grumpyStr = infoMetric[i].grumpy;
      String crankyStr = infoMetric[i].cranky;
      String happyStr = infoMetric[i].happy;
      String hyperStr = infoMetric[i].hyper;
      bool hyper = hyperStr.toLowerCase()  == 'true';
      bool grumpy = grumpyStr.toLowerCase()  == 'true';
      bool cranky = crankyStr.toLowerCase()  == 'true';
      bool happy = happyStr.toLowerCase()  == 'true';
      bool sleepy = sleepyStr.toLowerCase()  == 'true';

      sleepyChecked.add(sleepy);
      hyperChecked.add(hyper);
      happyChecked.add(happy); 
      crankyChecked.add(cranky); 
      grumpyChecked.add(grumpy);

    }
  }

  void switchLoadingAnimation() {
    setState(() {
      _loading = !_loading;
    });
  }
  
  void buildSubmitRequest(String childId, int index) async {
    bool sleepyMood = sleepyChecked[index];
    bool hyperMood = hyperChecked[index];
    bool happyMood = happyChecked[index];
    bool crankyMood = crankyChecked[index];
    bool grumpyMood = grumpyChecked[index];
    String jsonString = '''{"child_id":"$childId", "sleepy":"$sleepyMood", "hyper":"$hyperMood", "happy":"$happyMood", 
                          "cranky":"$crankyMood", "grumpy":"$grumpyMood"}''';
    print(jsonString);
    // Submit this to the api for updating 
    switchLoadingAnimation();
    bool result = await postChildMoodResults(jsonString);
    switchLoadingAnimation();
    if (result) {
      var _ = await showOkDialog(context, "Success");
      Navigator.pop(context);
    }

  }

  bool toggleCheckbox(bool value, int index, List list, String childId) {
      setState(() {
        list[index] = !list[index];
      });
      buildSubmitRequest(childId, index);
      return list[index]; 
  }

  Widget buildCheckbox(int index, List list, String childId) {
    return Material(
          // elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.lightBlue,
          child: Checkbox(
            value: list[index],
            onChanged: (value){toggleCheckbox(value, index, happyChecked, childId);},
            activeColor: Colors.lightBlue,
            checkColor: Colors.black,
            // tristate: false,
          )
      );
  }

  Widget buildCheckbox_1(int index, List list, String childId) {
  return Material(
        // elevation: 5.0,
        // borderRadius: BorderRadius.circular(30.0),
        color: Colors.lightBlue,
        child: Checkbox(
          value: list[index],
          onChanged: (value){toggleCheckbox(value, index, hyperChecked, childId);},
          activeColor: Colors.lightBlue,
          checkColor: Colors.black,
          tristate: false,
        )
    );
}

  Widget buildCheckbox_2(int index, List list, String childId) {
  return Material(
        // elevation: 5.0,
        // borderRadius: BorderRadius.circular(30.0),
        color: Colors.lightBlue,
        child: Checkbox(
          value: list[index],
          onChanged: (value){toggleCheckbox(value, index, sleepyChecked, childId);},
          activeColor: Colors.lightBlue,
          checkColor: Colors.black,
          tristate: false,
        )
    );
}

  Widget buildCheckbox_3(int index, List list, String childId) {
  return Material(
        // elevation: 5.0,
        // borderRadius: BorderRadius.circular(30.0),
        color: Colors.lightBlue,
        child: Checkbox(
          value: list[index],
          onChanged: (value){toggleCheckbox(value, index, crankyChecked, childId);},
          activeColor: Colors.lightBlue,
          checkColor: Colors.black,
          tristate: false,
        )
    );
}

  Widget buildCheckbox_4(int index, List list, String childId) {
  return Material(
        // elevation: 5.0,
        // borderRadius: BorderRadius.circular(30.0),
        color: Colors.lightBlue,
        child: Checkbox(
          value: list[index],
          onChanged: (value){toggleCheckbox(value, index, grumpyChecked, childId);},
          activeColor: Colors.lightBlue,
          checkColor: Colors.black,
          tristate: false,
        )
    );
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
              String childName = infoMetric[index].childName;
              String childId = infoMetric[index].childId;
              // String utcDate = infoMetric[index].utcDate;
 
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
                              Text("Happy"),
                              Text('Hyper'),
                              Text("Sleepy"),
                              Text('Cranky'),
                              Text("Grumpy")
                            ]),
                            TableRow(children: [
                              Text(childName),
                              buildCheckbox(index, happyChecked, childId),
                              buildCheckbox_1(index, hyperChecked, childId),
                              buildCheckbox_2(index, sleepyChecked, childId),
                              buildCheckbox_3(index, crankyChecked, childId),
                              buildCheckbox_4(index, grumpyChecked, childId)
                            ])
                          ],
                        ),
                      )
                ],
              );
            },
          ),
          loadingIndicator
        ],
      ),
    );
  }
}