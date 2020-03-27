import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'calls.dart'; 


class AddKidScreen extends StatelessWidget 
{
  // Pass the class a title 
  final String title;
  final String classroom; 
  final String emailAddr; 
  final String userName; 
  final String userId; 
  
  AddKidScreen({Key key, this.title, this.classroom, this.emailAddr, this.userId, this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: AddKidInfo(userName: this.userName, emailAddr: this.emailAddr, userId: this.userId)

    );
  }
}

class AddKidInfo extends StatelessWidget 
{
  // Must pass this the list that we want 
  final String userName;
  final String emailAddr; 
  final String userId; 
  

  AddKidInfo({Key key, this.userName, this.emailAddr, this.userId}) : super(key: key);

  void updateEmail(String emailAddr, String parentName, String childName)
  {
    String jsonString = '''{"user_name":"$userName", "email":"$emailAddr", "child_name":"$childName}'''; 
    print(jsonString);
    postModEmailResults(jsonString);
  }

  @override
  Widget build(BuildContext context) 
  {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    final emailController = TextEditingController(text: emailAddr);
    final emailField = TextField(
      obscureText: false,
      style: style,
      controller: emailController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter Parent Email Address",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final parentController = TextEditingController(text: emailAddr);
    final parentField = TextField(
      obscureText: false,
      style: style,
      controller: parentController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter Parent Name",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final kidController = TextEditingController(text: emailAddr);
    final kidField = TextField(
      obscureText: false,
      style: style,
      controller: kidController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter Child Name",
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
        onPressed:() {
          updateEmail(emailController.text, parentController.text, kidController.text);
        },
        child: Text("Add Child",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );

        return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 200.0,
                  child: Image.asset('assets/images/Kids_Day_Care.jpg',
                    //fit: BoxFit.contain,
                    //fit: BoxFit.contain
                  ),
                ),
                SizedBox(height: 45.0),
                kidField,
                SizedBox(height: 35.0),
                  emailField,
                SizedBox(
                  height: 35.0,
                ),
                  parentField,
                SizedBox(
                  height: 35.0,
                ),
                emailButton,
              ],
            );
  }
}