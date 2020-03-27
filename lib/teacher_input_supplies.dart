import 'package:child_checkin/SuppliesInfo.dart';
import 'package:child_checkin/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'SuppliesInfo.dart';
import 'calls.dart';



class ChildSuppliesScreen extends StatefulWidget
{
  // Pass the class a title 
  final String title;
  final String classroom; 

  ChildSuppliesScreen({Key key, this.title, this.classroom}) : super(key: key);

  @override
  ChildCheckSuppliesState createState() => ChildCheckSuppliesState();
}

class ChildCheckSuppliesState extends State<ChildSuppliesScreen> {
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
        child: FutureBuilder<List<SuppliesInfo>>(
          future: fetchTeacherSuppliesInfo(http.Client(), classroom),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                // ? CheckboxWidget(infoMetric: snapshot.data)
                ? CheckSuppliesScreen(infoMetric: snapshot.data)
                : Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)));
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }

}

class CheckSuppliesScreen extends StatefulWidget {
  final List<SuppliesInfo> infoMetric;


  CheckSuppliesScreen({Key key, this.infoMetric});

  @override
  CheckSuppliesState createState() => CheckSuppliesState();

}


class CheckSuppliesState extends State<CheckSuppliesScreen> {

  // Pass the class a title 
  // final String title;
  List<SuppliesInfo> infoMetric;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  List<bool> diapersChecked = []; 
  List<bool> spareClothesChecked = []; 
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    infoMetric = widget.infoMetric;

    for (var i = 0; i < infoMetric.length; i++) 
    {
      String diapersStr = infoMetric[i].diapers;
      String spareClothesStr = infoMetric[i].spareClothes;

      bool diapers = diapersStr.toLowerCase()  == 'true';
      bool spareClothes = spareClothesStr.toLowerCase()  == 'true';

      diapersChecked.add(diapers);
      spareClothesChecked.add(spareClothes);
    }
  }
  
  void switchLoadingAnimation() {
    setState(() {
      _loading = !_loading;
    });
  }

  void buildSubmitRequest(String childId, int index) async {
    bool diapers = diapersChecked[index];
    bool spareClothes = spareClothesChecked[index];
    String jsonString = '''{"child_id":"$childId", "diapers":"$diapers", "spare_clothes":"$spareClothes" }''';
    print(jsonString);
    // Submit this to the api for updating 
    switchLoadingAnimation();
    bool result = await postChildSuppliesResults(jsonString);
    switchLoadingAnimation();
    if (result) {
      var _ = await showOkDialog(context, "Success");
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
            onChanged: (value){toggleCheckbox(value, index, diapersChecked, childId);},
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
          onChanged: (value){toggleCheckbox(value, index, spareClothesChecked, childId);},
          activeColor: Colors.lightBlue,
          checkColor: Colors.black,
          tristate: false,
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _loading ? new Center(child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))) : new Container();
    print(infoMetric.length);
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
                          Text("Diapers"),
                          Text('Spare Clothes'),
                        ]),
                        TableRow(children: [
                          Text(childName),
                          buildCheckbox(index, diapersChecked, childId),
                          buildCheckbox_1(index, spareClothesChecked, childId),
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