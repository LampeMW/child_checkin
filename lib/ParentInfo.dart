class ParentInfo {
  final String userName;
  final String childId; 
  final String userId; 

  ParentInfo({this.userId, this.childId, this.userName});

  factory ParentInfo.fromJson(Map<String, dynamic> json) 
  {
    return ParentInfo(
      userName: json["user_name"] as String,
      childId: json["child_id"] as String, 
      userId: json["user_id"] as String,
    );
  }
}

