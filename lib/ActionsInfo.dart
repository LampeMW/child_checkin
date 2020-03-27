class ActionsInfo {
  final String childLastCheckedOut;
  final String childName; 
  final String childLastCheckedIn;
  final String childId; 
  final String checkedIn; 

  ActionsInfo({this.childName, this.childLastCheckedIn, this.childLastCheckedOut, this.childId, this.checkedIn});

  factory ActionsInfo.fromJson(Map<String, dynamic> json) 
  {
    return ActionsInfo(
      childName: json["child_name"] as String,
      childId: json["child_id"] as String, 
      childLastCheckedIn: json["child_last_checked_in"] as String,
      childLastCheckedOut: json["child_last_checked_out"] as String,
      checkedIn: json["child_checked_in"] as String
    );
  }
}

