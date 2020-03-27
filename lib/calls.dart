import 'package:child_checkin/ParentInfo.dart';
import 'package:flutter/foundation.dart';
import 'ActionsInfo.dart';
import 'NapInfo.dart';
import 'MealsInfo.dart';
import 'KidInfo.dart';
import 'MoodInfo.dart';
import 'BathroomInfo.dart';
import 'SuppliesInfo.dart';
import 'UserInfo.dart';
import 'ParentInfo.dart';
import 'ParentKidInfo.dart'; 
import 'ParentBathroomInfo.dart';
import 'ParentNapInfo.dart'; 
import 'ParentChildNeeds.dart';
import 'LoginInfo.dart'; 
import 'dart:convert';
import 'package:http/http.dart' as http;

final String apiUrl = "https://xy1ckx6fl9.execute-api.us-east-1.amazonaws.com/production"; 

// This function converts a json into a list
List<ActionsInfo> parseLoginInfo(String responseBody) 
{
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<ActionsInfo>((json) => ActionsInfo.fromJson(json)).toList();
}

Future<List<ActionsInfo>> fetchChildRoomInfo(http.Client client, String classroom) async 
{
  // Make the api call 
  String url = apiUrl + "/getsigninstatus?child_room=$classroom";
  // // String results = makePostRequest(url, json);
  var response = await http.get(url);  
  return compute(parseLoginInfo, response.body);
}

List<ParentInfo> parseParentInfo(String responseBody) 
{
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<ParentInfo>((json) => ParentInfo.fromJson(json)).toList();
}

Future<List<ParentInfo>> fetchParentInfo(http.Client client, String childId) async 
{
    // Make the api call 
  String url = apiUrl + "/getkidparents?child_id=$childId";
  // // String results = makePostRequest(url, json);
  var response = await http.get(url);  
  return compute(parseParentInfo, response.body);
}

List<ParentKidInfo> parseParentKidInfo(String responseBody) 
{
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<ParentKidInfo>((json) => ParentKidInfo.fromJson(json)).toList();
}

Future<List<ParentKidInfo>> fetchParentKidInfo(http.Client client, String userId) async 
{
    // Make the api call 
    print(userId);
  String url = apiUrl + "/getparentkids?user_id=$userId";
  // // String results = makePostRequest(url, json);
  var response = await http.get(url); 
  return compute(parseParentKidInfo, response.body);
}

List<ParentNeedsInfo> parseParentNeedsInfo(String responseBody) 
{
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<ParentNeedsInfo>((json) => ParentNeedsInfo.fromJson(json)).toList();
}

Future<List<ParentNeedsInfo>> fetchParentNeedsInfo(http.Client client, String childId) async 
{
    // Make the api call 
    print(childId);
  String url = apiUrl + "/getparentneed?child_id=$childId";
  // // String results = makePostRequest(url, json);
  var response = await http.get(url); 
  return compute(parseParentNeedsInfo, response.body);
}

// This function converts a json into a list
List<NapInfo> parseTeacherNapInfo(String responseBody) 
{
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<NapInfo>((json) => NapInfo.fromJson(json)).toList();
}

Future<List<NapInfo>> fetchChildNapInfo(http.Client client, String classroom) async 
{
  // Make the api call 
  String url = apiUrl + "/getteachernaptime?child_room=$classroom";
  // // String results = makePostRequest(url, json);
  var response = await http.get(url);  
  return compute(parseTeacherNapInfo, response.body);
}

Future<bool> postChildNapResults(String jsonString) async {
  String url = apiUrl + "/updatechildnaptime";
  bool result = await makePostRequest(url, jsonString);
  return result;
}

// This function converts a json into a list
List<MealsInfo> parseMealsInfo(String responseBody) 
{
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<MealsInfo>((json) => MealsInfo.fromJson(json)).toList();
}

Future<List<MealsInfo>> fetchChildMealsInfo(http.Client client, String childRoom) async 
{
  // Make the api call 
  String url = apiUrl + "/getchildate?child_room=$childRoom";
  // // String results = makePostRequest(url, json);
  var response = await http.get(url);  
  print(response.statusCode); 
  return compute(parseMealsInfo, response.body);
}

// This function converts a json into a list
List<MealsInfo> parseParentMealsInfo(String responseBody) 
{
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<MealsInfo>((json) => MealsInfo.fromJson(json)).toList();
}

Future<List<MealsInfo>> fetchParentChildMealsInfo(http.Client client, String childId) async 
{
  // Make the api call 
  print(childId);
  String url = apiUrl + "/getparentate?child_id=$childId";
  // // String results = makePostRequest(url, json);
  var response = await http.get(url);  
  print(response.statusCode); 
  return compute(parseMealsInfo, response.body);
}


Future<bool> postChildMealsResults(String jsonString) async {
  String url = apiUrl + "/updatechildate";
  bool result = await makePostRequest(url, jsonString);
  return result;
}


List<KidInfo> parseRoomInfo(var responseBody) 
{
  // print("it did something");
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  // print("parsed");
  return parsed.map<KidInfo>((json) => KidInfo.fromJson(json)).toList();
}

Future<List<KidInfo>>fetchChildInfo(http.Client client, String classroom)  async
{
    // Make the api call 
  String url = apiUrl + "/getchildren?child_room=$classroom";
  // // String results = makePostRequest(url, json);
  var response = await http.get(url);  

  return compute(parseRoomInfo, response.body);
}

// This function converts a json into a list
List<MealsInfo> parseSignInResults(String responseBody) 
{
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<MealsInfo>((json) => MealsInfo.fromJson(json)).toList();
}

void postSigninResults(childId, signInStatus) async 
{
  String url = apiUrl + "/updatechildinfo";
  String json = '''{
                  "child_name": "Steven Honsaker",
                  "child_id": "$childId",
                  "child_age": "23",
                  "child_allergies": "Peanuts",
                  "child_address": "248 Oak Street",
                  "child_checked_in": "$signInStatus",
                  "child_last_checked_in": "2020-02-12 14:00",
                  "child_last_checked_out": "2020-02-12 18:00",
                  "parent_contact_info": {
                    "phone_number": "513-771-7777",
                    "email_address": "jsmith@gmail.com",
                    "parent_id": "12345"
                  }
                }''';

  // Make the api call 
  makePostRequest(url, json);


  // String t = '''[{"record_id": "14:00", "meal": "dinner", "child_name": "Steven", "description":"Pizza", "amount":"some"}, 
  //                 {"record_id": "14:00", "meal": "lunch", "child_name": "Steven", "description":"Pizza", "amount":""},
  //                 {"record_id": "14:00", "meal": "snack", "child_name": "Steven", "description":"Pizza", "amount":"none"}
  //                   ]''';
  // print(t);

  // Use the compute function to run parseLoginInfo in a separate isolate
  // Not sure why it runs in a compute function, but this calls the a function that creates a list from this result
  // return compute(parseLoginInfo, response.body);


  // Re-evaluate if this works
  // return compute(parseSignInResults, t);
}

Future<bool> postChildMoodResults(String jsonString) async
{
  String url = apiUrl + "/updatechildmood";
  bool result = await makePostRequest(url, jsonString);
  return result;
}

List<MoodInfo> parseMoodInfo(var responseBody) 
{
  // print("it did something");
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  // print("parsed");
  return parsed.map<MoodInfo>((json) => MoodInfo.fromJson(json)).toList();
}

Future<List<MoodInfo>>fetchChildMoodInfo(http.Client client, String classroom)  async
{
    // Make the api call 
  String url = apiUrl + "/getteachermoods?child_room=$classroom";
  // // String results = makePostRequest(url, json);
  var response = await http.get(url);  

  return compute(parseMoodInfo, response.body);
}

List<BathroomInfo> parseTeacherBathroomInfo(var responseBody) 
{
  // print("it did something");
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  // print("parsed");
  return parsed.map<BathroomInfo>((json) => BathroomInfo.fromJson(json)).toList();
}

Future<List<BathroomInfo>>fetchTeacherBathroomInfo(http.Client client, String classroom)  async
{
    // Make the api call 
  String url = apiUrl + "/getteacherbathroom?child_room=$classroom";
  // // String results = makePostRequest(url, json);
  var response = await http.get(url);  

  return compute(parseTeacherBathroomInfo, response.body);
}

List<ParentBathroomInfo> parseParentBathroomInfo(var responseBody) 
{
  // print("it did something");
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<ParentBathroomInfo>((json) => ParentBathroomInfo.fromJson(json)).toList();
}

Future<List<ParentBathroomInfo>>fetchParentBathroomInfo(http.Client client, String childId)  async
{
    // Make the api call 
  String url = apiUrl + "/getparentbathroom?child_id=$childId";
  // // String results = makePostRequest(url, json);
  var response = await http.get(url);  
  print(response.statusCode);
  return compute(parseParentBathroomInfo, response.body);
}


List<ParentNapInfo> parseParentNapInfo(var responseBody) 
{
  // print("it did something");
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<ParentNapInfo>((json) => ParentNapInfo.fromJson(json)).toList();
}

Future<List<ParentNapInfo>>fetchParentNapInfo(http.Client client, String childId)  async
{
    // Make the api call 
  String url = apiUrl + "/getparentnap?child_id=$childId";
  // // String results = makePostRequest(url, json);
  var response = await http.get(url);  
  return compute(parseParentNapInfo, response.body);
}

Future<bool> postChildBathroomResults(String jsonString) async 
{
  String url = apiUrl + "/updatechildbathroom";
  bool result = await makePostRequest(url, jsonString);
  return result;
}

List<SuppliesInfo> parseTeacherSuppliesInfo(var responseBody) 
{
  // print("it did something");
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  // print("parsed");
  return parsed.map<SuppliesInfo>((json) => SuppliesInfo.fromJson(json)).toList();
}

Future<List<SuppliesInfo>>fetchTeacherSuppliesInfo(http.Client client, String classroom)  async
{
    // Make the api call 
  String url = apiUrl + "/getteachersupplies?child_room=$classroom";
  print(url);
  // // String results = makePostRequest(url, json);
  var response = await http.get(url);  
  print(response.body);
  return compute(parseTeacherSuppliesInfo, response.body);
}

Future<bool> postChildSuppliesResults(String jsonString) async {
  String url = apiUrl + "/updatechildsupplies";
  bool result = await makePostRequest(url, jsonString);
  return result;
}

void postModEmailResults(String jsonString)
{
  String url = apiUrl + "/updateuseremail";
  makePostRequest(url, jsonString);
}

void postModPasswordResults(String jsonString)
{
  String url = apiUrl + "/updateuserpassword";
  makePostRequest(url, jsonString);
}

Future<bool> postchildCheckinResults(String jsonString) async {
  String url = apiUrl + "/updatechildcheckin";
  bool result = await makePostRequest(url, jsonString);
  return result;
}

void postAddKidResults(String jsonString)
{
  String url = apiUrl + "/addKid";
  makePostRequest(url, jsonString);
}


List<UserInfo> parseUserInfo(var responseBody) 
{
  // print("it did something");
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  // print("parsed");
  return parsed.map<UserInfo>((json) => UserInfo.fromJson(json)).toList();
}

Future<List<UserInfo>>fetchUserInfo(http.Client client, String userId)  async
{
  // Make the api call 
  print("made it to the request"); 
  String url = apiUrl + "/getuserinfo?user_id=$userId";
  // // String results = makePostRequest(url, json);
  var response = await http.get(url);  
  print(response.statusCode); 
  return compute(parseUserInfo, response.body);
}


List<LoginInfo> parseNewLoginInfo(var responseBody) 
{
  // print("it did something");
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  // print("parsed");
  return parsed.map<LoginInfo>((json) => LoginInfo.fromJson(json)).toList();
}

Future<List<LoginInfo>>fetchNewLoginInfo(http.Client client, String email, String password)  async
{
    // Make the api call 
  String url = apiUrl + "/login?email=$email&password=$password";
  // // String results = makePostRequest(url, json);
  var response = await http.get(url);  
  return compute(parseNewLoginInfo, response.body);
}



Future<bool> makePostRequest(String url, String jsonString) async {
  // set up POST request arguments
  Map<String, String> headers = {"Content-type": "application/json"};
  // String json = '{"title": "Hello", "body": "body text", "userId": 1}';
  // make POST request
  final response = await http.post(url, headers: headers, body: jsonString);
  // check the status code for the result
  int statusCode = response.statusCode;
  // this API passes back the id of the new item added to the body
  return statusCode == 200;
}