class KidInfo {
  final String recordId;
  final String amount;
  final String childName; 
  final String description;
  final String meal; 
  final String childId; 
  final String childRoom; 
  final String childCheckedIn; 
  
  KidInfo({this.recordId, this.childName, this.description, this.amount, this.meal, this.childId, this.childRoom, this.childCheckedIn});

  factory KidInfo.fromJson(Map<String, dynamic> json) 
  {
    return KidInfo(
      recordId: json['record_id'] as String,
      childName: json["child_name"] as String,
      childId: json["child_id"] as String, 
      childRoom: json["child_room"] as String,
      childCheckedIn: json["child_checked_in"] as String, 
      description: json["description"] as String,
      amount: json["amount"] as String,
      meal: json["meal"] as String,
    );
  }
}

