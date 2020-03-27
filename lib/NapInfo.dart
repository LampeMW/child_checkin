class NapInfo {
  final String startTime;
  final String endTime;
  final String childName; 
  final String childId; 
  final String utcDate; 

  NapInfo({this.startTime, this.childName, this.endTime, this.utcDate, this.childId});

  factory NapInfo.fromJson(Map<String, dynamic> json) 
  {
    return NapInfo(
      startTime: json['start_time'] as String,
      utcDate: json['utc_date'] as String,
      childId: json['child_id'] as String,
      childName: json["child_name"] as String,
      endTime: json["end_time"] as String
    );
  }
}