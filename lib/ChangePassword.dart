import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'calls.dart'; 


class ModPasswordScreen extends StatelessWidget 
{
  // Pass the class a title 
  final String title;
  final String classroom; 
  final String emailAddr; 
  final String userName; 
  final String userId; 
  
  ModPasswordScreen({Key key, this.title, this.classroom, this.emailAddr, this.userId, this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ModPasswordInfo(userName: this.userName, emailAddr: this.emailAddr, userId: this.userId)

    );
  }
}

class ModPasswordInfo extends StatelessWidget 
{
  // Must pass this the list that we want 
  final String userName;
  final String emailAddr; 
  final String userId; 
  
  ModPasswordInfo({Key key, this.userName, this.emailAddr, this.userId}) : super(key: key);

  void updateEmail(String password, String userId)
  {
    String jsonString = '''{"user_id":"$userId", "password":"$password" }'''; 
    print(jsonString);
    postModPasswordResults(jsonString);
  }

  @override
  Widget build(BuildContext context) 
  {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    final passwordController = TextEditingController();
    final passwordField = TextField(
      obscureText: false,
      style: style,
      controller: passwordController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter New Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordButton = Material(
      color: Colors.lightBlue[900],
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),

      child: MaterialButton(
        color: Colors.lightBlue[900],
        clipBehavior: Clip.antiAlias,
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed:() {
          updateEmail(passwordController.text, userId);
        },
        child: Text("Update Password",
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
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                passwordButton,
              ],
            );
  }
}