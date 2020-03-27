import 'package:child_checkin/BathroomInfo.dart';
import 'package:child_checkin/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'BathroomInfo.dart';
import 'calls.dart';



class ChildBathroomScreen extends StatefulWidget
{
  // Pass the class a title 
  final String title;
  final String classroom; 

  ChildBathroomScreen({Key key, this.title, this.classroom}) : super(key: key);

  @override
  ChildCheckBathroomState createState() => ChildCheckBathroomState();
}

class ChildCheckBathroomState extends State<ChildBathroomScreen> {
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
        child: FutureBuilder<List<BathroomInfo>>(
          future: fetchTeacherBathroomInfo(http.Client(), classroom),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                // ? CheckboxWidget(infoMetric: snapshot.data)
                ? CheckBathroomScreen(infoMetric: snapshot.data)
                : Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)));
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }

}

class CheckBathroomScreen extends StatefulWidget {
  final List<BathroomInfo> infoMetric;


  CheckBathroomScreen({Key key, this.infoMetric});

  @override
  CheckBathroomState createState() => CheckBathroomState();

}


class CheckBathroomState extends State<CheckBathroomScreen> {

  // Pass the class a title 
  // final String title;
  List<BathroomInfo> infoMetric;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  List<bool> noneChecked = [];
  List<bool> someChecked = [];
  List<bool> bmChecked = []; 
  List<bool> pottyChecked = []; 
  List<bool> triedPottyChecked = []; 
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    infoMetric = widget.infoMetric;

    for (var i = 0; i < infoMetric.length; i++) 
    {
      
      String noneStr = infoMetric[i].none;
      String someStr = infoMetric[i].some;
      String triedStr = infoMetric[i].triedPotty;
      String pottyStr = infoMetric[i].potty;
      String bmStr = infoMetric[i].bm;
      bool none = noneStr.toLowerCase()  == 'true';
      bool some = someStr.toLowerCase()  == 'true';
      bool triedPotty = triedStr.toLowerCase()  == 'true';
      bool potty = pottyStr.toLowerCase()  == 'true';
      bool bm = bmStr.toLowerCase()  == 'true';

      noneChecked.add(none);
      someChecked.add(some);
      bmChecked.add(bm); 
      pottyChecked.add(potty);
      triedPottyChecked.add(triedPotty);
    }
  }

  void switchLoadingAnimation() {
    setState(() {
      _loading = !_loading;
    });
  }

  void buildSubmitRequest(String childId, int index) async {
    bool wet = noneChecked[index];
    bool dry = someChecked[index];
    bool bm = bmChecked[index];
    bool triedPotty = triedPottyChecked[index];
    bool potty = pottyChecked[index];
    String jsonString = '''{"child_id":"$childId", "wet":"$wet", "dry":"$dry", "bm":"$bm", 
                          "triedPotty":"$triedPotty", "potty":"$potty"}''';
    print(jsonString);
    switchLoadingAnimation();
    bool result = await postChildBathroomResults(jsonString);
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
            onChanged: (value){toggleCheckbox(value, index, noneChecked, childId);},
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
          onChanged: (value){toggleCheckbox(value, index, someChecked, childId);},
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
          onChanged: (value){toggleCheckbox(value, index, bmChecked, childId);},
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
          onChanged: (value){toggleCheckbox(value, index, pottyChecked, childId);},
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
          onChanged: (value){toggleCheckbox(value, index, triedPottyChecked, childId);},
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
          Column(
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
                                  Text("Wet"),
                                  Text('Dry'),
                                  Text("BM"),
                                  Text('Potty'),
                                  Text("Tried Potty")
                                ]),
                                TableRow(children: [
                                  Text(childName),
                                  buildCheckbox(index, noneChecked, childId),
                                  buildCheckbox_1(index, someChecked, childId),
                                  buildCheckbox_2(index, bmChecked, childId),
                                  buildCheckbox_3(index, pottyChecked, childId),
                                  buildCheckbox_4(index, triedPottyChecked, childId)
                                ])
                              ],
                            ),
                          )
                    ],
                  );
                },
              ),
            ],
          ),
          loadingIndicator
        ],
      ),
    );
  }
}