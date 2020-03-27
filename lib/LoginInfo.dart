class LoginInfo {
  final String childId;
  final String parentId;
  final String parentName;
  final String childName; 
  
  LoginInfo({this.childId, this.parentId, this.parentName, this.childName});

  factory LoginInfo.fromJson(Map<String, dynamic> json) 
  {
    return LoginInfo(
      childId: json['child_id'] as String,
      // childName: json["child_name"] as String,
      parentId: json["user_id"] as String,
      parentName: json["user_name"] as String,
      childName: json["child_name"] as String
    );
  }
}

