import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ChangeEmail.dart'; 
import 'ChangePassword.dart'; 
import 'UserInfo.dart';
import 'calls.dart'; 


class ModAccountScreen extends StatelessWidget 
{
  // Pass the class a title 
  final String title;
  final String classroom; 
  final String userId; 

  ModAccountScreen({Key key, this.title, this.classroom, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: 
       Padding(
        child: FutureBuilder<List<UserInfo>>(
          future: fetchUserInfo(http.Client(), userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? ModAccountInfo(infoMetric: snapshot.data, userId: userId)
                : Center(child: CircularProgressIndicator());
          },
        ),

        padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 10.0),
      ),
    );
  }
}

class ModAccountInfo extends StatelessWidget 
{
  // Must pass this the list that we want 
  final List<UserInfo> infoMetric;
  final String userId; 

  ModAccountInfo({Key key, this.infoMetric, this.userId}) : super(key: key);

  switchScreens(btnName, context, modMetric)
  {
   // Switch the screen after selecting a class room
    String title = "Select Action";
    String classroom = btnName;
    print(classroom);
    if(classroom == "Change Email")
    {
      ModEmailScreen emailScreen = new ModEmailScreen(title: title, classroom: btnName, userId: userId);
      Navigator.push(context, new MaterialPageRoute(builder: (context) => emailScreen));
    }
    else
    {
      ModPasswordScreen pwdScreen = new ModPasswordScreen(title: title, classroom: btnName, userId: userId);
      Navigator.push(context, new MaterialPageRoute(builder: (context) => pwdScreen));
    }

  }

  @override
  Widget build(BuildContext context) 
  {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    return ListView.builder(
      // This needs to be the object we pass from the api 
      itemCount: infoMetric.length,
      itemBuilder: (context, index) 
      {
        String btnName = infoMetric[index].emailAddr;   
        print(btnName);

        final emailField = TextField(
          obscureText: false,
          style: style,
          controller: TextEditingController(text: infoMetric[index].emailAddr),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter New Email Address",
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
        final nameField = TextField(
          obscureText: false,
          style: style,
          controller: TextEditingController(text: infoMetric[index].userName),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Name",
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
              switchScreens("Change Email", context, infoMetric[index]);
            },
            child: Text("Change Email",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
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
              switchScreens("Change Password", context, infoMetric[index]);
            },
            child: Text("Change Password",
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
                emailField,
                SizedBox(height: 25.0),
                nameField,
                SizedBox(
                  height: 35.0,
                ),
                emailButton,
                SizedBox(
                  height: 15.0,
                ),
                passwordButton
              ],
            );
      },
    );
  }
}