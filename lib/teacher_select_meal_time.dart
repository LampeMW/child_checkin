import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'MealsInfo.dart';
import 'calls.dart';
import 'teacher_select_what_meal.dart'; 


class ChildMealScreen extends StatefulWidget
{
  // Pass the class a title 
  final String title;
  final String mealTime;
  final String classroom;  

  ChildMealScreen({Key key, this.title, this.mealTime, this.classroom}) : super(key: key);

  @override
  ChildCheckMealState createState() => ChildCheckMealState();
}

class ChildCheckMealState extends State<ChildMealScreen> {
  String title;
  String mealTime; 
  String childRoom; 
  @override
  void initState() {
    super.initState();
    title = widget.title;
    mealTime = widget.mealTime;
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
        child: FutureBuilder<List<MealsInfo>>(
          future: fetchChildMealsInfo(http.Client(), childRoom),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                // ? CheckboxWidget(infoMetric: snapshot.data)
                ? CheckMealScreen(infoMetric: snapshot.data, mealTime:mealTime)
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
  final String mealTime; 

  CheckMealScreen({Key key, this.infoMetric, this.mealTime});

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
    mealTime = widget.mealTime; 

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
                          "allEaten":"$allEaten", "meal_time": "$mealTime" }''';
    print(jsonString);

    String title = "What did they eat?";
    // SecondScreen home = new SecondScreen(title: title); 
    ChildFoodScreen childMeals = new ChildFoodScreen(title: title, jsonString: jsonString);
    Navigator.push(context, new MaterialPageRoute(builder: (context) => childMeals));
    // Submit this to the api for updating 
    // postChildMealsResults(jsonString);

  }

  bool toggleCheckbox(bool value, int index, List list, String mealTime, String childId) {
      setState(() {
        list[index] = !list[index];
      });
      buildSubmitRequest(childId, index, mealTime);
      return list[index]; 
  }

  Widget buildCheckbox(int index, List list, String mealTime, String childId) {
    return Material(
          // elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.lightBlue,
          child: Checkbox(
            value: list[index],
            onChanged: (value){toggleCheckbox(value, index, noneChecked, mealTime, childId);},
            activeColor: Colors.lightBlue,
            checkColor: Colors.black,
            // tristate: false,
          )
      );
  }

  Widget buildCheckbox_1(int index, List list, String mealTime, String childId) {
    return Material(
          // elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.lightBlue,
          child: Checkbox(
            value: list[index],
            onChanged: (value){toggleCheckbox(value, index, someChecked, mealTime, childId);},
            activeColor: Colors.lightBlue,
            checkColor: Colors.black,
            // tristate: false,
          )
      );
  }

 @override
  Widget build(BuildContext context) 
  {
    // return Column(
    //   children: <Widget>[
    //     SizedBox(
    //       height: 200.0,
    //       child: Image.asset('assets/images/Kids_Day_Care.jpg',
    //       ),
    //     ),
    return Scaffold(
      body:    
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
                          Text("None"),
                          Text('Some'),
                        ]),
                        TableRow(children: [
                          Text(childName),
                          buildCheckbox(index, noneChecked, mealTime, childId),
                          buildCheckbox_1(index, someChecked, mealTime, childId),
                        ])
                      ],
                    ),
                  )
            ],
          );
        },
      ),
    );
    // ]
// );
  }
}