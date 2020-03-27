import 'package:child_checkin/helpers.dart';
import 'package:flutter/material.dart';
import 'calls.dart';
import 'dart:convert';

class ChildFoodScreen extends StatefulWidget {
  final String title;
  final String jsonString;

  ChildFoodScreen({this.title, this.jsonString});

  @override
  _ChildFoodScreenState createState() => _ChildFoodScreenState();
}

class _ChildFoodScreenState extends State<ChildFoodScreen> {
  bool _loading = false;

  void switchLoadingAnimation() {
    setState(() {
      _loading = !_loading;
    });
  }

  void updateEmail(String what, String jsonString) async {
    Map modJsonString = json.decode(jsonString);
    modJsonString["what"] = what;
    String updatedJsonString = json.encode(modJsonString);
    // String jsonString = '''{"user_id":"${userId}", "what":"${emailAddr}" }''';
    print(updatedJsonString);
    switchLoadingAnimation();
    bool result = await postChildMealsResults(updatedJsonString);
    switchLoadingAnimation();
    if (result) {
      var _ = await showOkDialog(context, "Success");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _loading ? new Center(child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))) : new Container();

    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    final emailController = TextEditingController();
    final emailField = TextField(
      obscureText: false,
      style: style,
      controller: emailController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter Meal",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final emailButton = Material(
      color: Colors.lightBlue[900],
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        color: Colors.lightBlue[900],
        clipBehavior: Clip.antiAlias,
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          updateEmail(emailController.text, widget.jsonString);
        },
        child: Text("Submit Meal",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 200.0,
                child: Image.asset(
                  'assets/images/Kids_Day_Care.jpg',
                  //fit: BoxFit.contain,
                  //fit: BoxFit.contain
                ),
              ),
              SizedBox(height: 45.0),
              emailField,
              SizedBox(
                height: 35.0,
              ),
              emailButton,
            ],
          ),
          loadingIndicator
        ],
      ),
    );
  }
}
