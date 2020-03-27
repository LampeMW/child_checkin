class ParentKidInfo {
  final String childId;
  final String parentId;
  final String parentName;
  final String childName; 
  
  ParentKidInfo({this.childId, this.parentId, this.parentName, this.childName});

  factory ParentKidInfo.fromJson(Map<String, dynamic> json) 
  {
    return ParentKidInfo(
      childId: json['child_id'] as String,
      // childName: json["child_name"] as String,
      parentId: json["user_id"] as String,
      parentName: json["user_name"] as String,
      childName: json["child_name"] as String
    );
  }
}

