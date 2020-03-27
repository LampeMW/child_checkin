class UserInfo {
  final String userId;
  final String emailAddr;
  final String userName; 
  final String password;
  final String utcDate; 

  
  UserInfo({this.userId, this.emailAddr, this.userName, this.password, this.utcDate});

  factory UserInfo.fromJson(Map<String, dynamic> json) 
  {
    return UserInfo(
      userId: json['user_id'] as String,
      emailAddr: json["email"] as String,
      userName: json["user_name"] as String, 
      password: json["password"] as String,
      utcDate: json["utc_date"] as String
    );
  }
}

