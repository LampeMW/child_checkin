import 'package:flutter/material.dart';
import 'checkin_screen.dart';
import 'checkin_admin_screen.dart'; 
import 'parent_checkin_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DayCare App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.lightBlue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  login(String email, String password)
  {
    // This method should authenticate with the DB and log the user in
    print(email); 
    print(password);
    // FutureBuilder<List<LoginInfo>>(
    //     future: fetchNewLoginInfo(http.Client(), email, password),
    //     builder: (context, snapshot) {
    //         if (snapshot.hasError) print(snapshot.error);

    //         return snapshot.hasData
    //             ? switchScreens(snapshot.data)
    //             : Center(child: CircularProgressIndicator());
    //       },
    //     // To show a spinner while loading
    //     // return CircularProgressIndicator();
    //   );
    switchScreens();

  }

  switchScreens()
  {
      // Switch the screen after the user has been authenticated properly
      String userId = "6039272508955088"; 

      String title = "Select Admin Classroom";
      print("Login Status successful");
      if (title == "Select Child")
      {
        ParentCheckInScreen checkin = new ParentCheckInScreen(title: title, userId: userId);
        Navigator.push(context, new MaterialPageRoute(builder: (context) => checkin));

      }
      else if (title == "Select Classroom")
      {
        CheckInScreen checkin = new CheckInScreen(title: title, userId:userId);
        Navigator.push(context, new MaterialPageRoute(builder: (context) => checkin));

      }
      else if (title == "Select Admin Classroom")
      {
        AdminCheckInScreen checkin = new AdminCheckInScreen(title: title, userId:userId);
        Navigator.push(context, new MaterialPageRoute(builder: (context) => checkin));
      }
  }

  @override
  // Widget build(BuildContext context) {
  build(BuildContext context) {
    final emailController = TextEditingController();
    final pwdController = TextEditingController();
    final emailField = TextField(
      obscureText: false,
      controller: emailController,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      style: style,
      controller: pwdController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      // color: Color(0xff01A0C7),
      color: Colors.lightBlue[900],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed:() {
          login(emailController.text, pwdController.text);
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.lightBlue,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 200.0,
                  child: Image.asset('assets/images/Kids_Day_Care.jpg',
                  ),
                ),
                SizedBox(height: 45.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

