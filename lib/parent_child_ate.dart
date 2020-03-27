import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'MealsInfo.dart';
import 'calls.dart';
import 'teacher_select_what_meal.dart'; 


class ChildCheckFoodScreen extends StatefulWidget
{
  // Pass the class a title 
  final String title;
  final String childId;


  ChildCheckFoodScreen({Key key, this.title, this.childId}) : super(key: key);

  @override
  CheckFoodScreen createState() => CheckFoodScreen();
}

class CheckFoodScreen extends State<ChildCheckFoodScreen> {
  String title;
  String childId; 
  @override
  void initState() {
    super.initState();
    title = widget.title;
    childId = widget.childId;
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        child: FutureBuilder<List<MealsInfo>>(
          future: fetchParentChildMealsInfo(http.Client(), childId),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                // ? CheckboxWidget(infoMetric: snapshot.data)
                ? CheckMealScreen(infoMetric: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }

}

class CheckMealScreen extends StatefulWidget {
  final List<MealsInfo> infoMetric;

  CheckMealScreen({Key key, this.infoMetric});

  @override
  CheckMealState createState() => CheckMealState();

}


class CheckMealState extends State<CheckMealScreen> {

  // Pass the class a title 
  // final String title;
  List<MealsInfo> infoMetric;
  String mealTime; 
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  List<bool> noneChecked = [];
  List<bool> someChecked = [];
  List<bool> mostChecked = [];
  List<bool> allChecked = [];

  @override
  void initState() {
    super.initState();
    infoMetric = widget.infoMetric;

    for (var i = 0; i < infoMetric.length; i++) 
    {
      String noneStr = infoMetric[i].none;
      String someStr = infoMetric[i].some;
      String mostStr = infoMetric[i].most;
      String allStr = infoMetric[i].all;

      bool none = noneStr.toLowerCase()  == 'true';
      bool some = someStr.toLowerCase()  == 'true';
      bool most = mostStr.toLowerCase()  == 'true';
      bool all = allStr.toLowerCase()  == 'true';

      noneChecked.add(none);
      someChecked.add(some);
      mostChecked.add(most); 
      allChecked.add(all); 

    }
  }

  void buildSubmitRequest(String childId, int index, String mealTime)
  {
    bool noneEaten = noneChecked[index];
    bool someEaten = someChecked[index];
    bool mostEaten = mostChecked[index];
    bool allEaten = allChecked[index];
    String jsonString = '''{"child_id":"$childId", "noneEaten":"$noneEaten", "someEaten":"$someEaten", "mostEaten":"$mostEaten", 
                          "allEaten":"$allEaten", "meal_time": "$mealTime"}''';
    print(jsonString);

    String title = "What did they eat?";
    // SecondScreen home = new SecondScreen(title: title); 
    ChildFoodScreen childMeals = new ChildFoodScreen(title: title, jsonString: jsonString);
    Navigator.push(context, new MaterialPageRoute(builder: (context) => childMeals));
    // Submit this to the api for updating 
    // postChildMealsResults(jsonString);

  }

  // bool toggleCheckbox(bool value, int index, List list, String mealTime, String childId) {
  //     setState(() {
  //       list[index] = !list[index];
  //     });
  //     buildSubmitRequest(childId, index, mealTime);
  //     return list[index]; 
  // }

  Widget buildCheckbox(int index, List list, String childId) {
    return Material(
          // elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.lightBlue,
          child: Checkbox(
            value: list[index],
            activeColor: Colors.lightBlue,
            checkColor: Colors.black,
            onChanged: (value) {

            },
            // tristate: false,
          )
      );
  }

  Widget buildCheckbox_1(int index, List list, String childId) {
    return Material(
          // elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.lightBlue,
          child: Checkbox(
            value: list[index],
            activeColor: Colors.lightBlue,
            checkColor: Colors.black,
            onChanged: (value) {
              
            },
            // tristate: false,
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
            activeColor: Colors.lightBlue,
            checkColor: Colors.black,
            onChanged: (value) {
              
            },
            // tristate: false,
          )
      );
  }
    Widget buildCheckbox_3(int index, List list, String childId) {
    return Material(
          // elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.lightBlue,
          child: Checkbox(
            value: list[index],
            activeColor: Colors.lightBlue,
            checkColor: Colors.black,
            onChanged: (value) {
              
            },
            // tristate: false,
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
                          Text("None"),
                          Text('Some'),
                          Text("Most"), 
                          Text("All"),
                          Text("What did they eat?"),
                          Text("When did they eat?")
                        ]),
                        TableRow(children: [
                          Text(childName),
                          buildCheckbox(index, noneChecked, childId),
                          buildCheckbox_1(index, someChecked, childId),
                          buildCheckbox_2(index, mostChecked, childId),
                          buildCheckbox_3(index, allChecked, childId),
                          Text(infoMetric[index].what),
                          Text(infoMetric[index].mealTime)
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