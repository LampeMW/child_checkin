class ParentNapInfo {
  final String childId; 
  final String utcDate; 
  final String childName; 
  final String startTime; 
  final String endTime; 

  
  ParentNapInfo({this.startTime, this.childId, this.utcDate, this.childName, this.endTime});

  factory ParentNapInfo.fromJson(Map<String, dynamic> json) 
  {
    return ParentNapInfo(
      startTime: json["start_time"] as String, 
      endTime: json["end_time"] as String, 
      childId: json["child_id"] as String,
      utcDate: json["utc_date"] as String,
      childName: json["child_name"] as String,
    );
  }
}

