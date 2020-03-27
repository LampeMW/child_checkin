class ParentBathroomInfo {
  final String childId; 
  final String utcDate; 
  final String childName; 
  final String type; 

  
  ParentBathroomInfo({this.type, this.childId, this.utcDate, this.childName});

  factory ParentBathroomInfo.fromJson(Map<String, dynamic> json) 
  {
    return ParentBathroomInfo(
      type: json["output"] as String, 
      childId: json["child_id"] as String,
      utcDate: json["utc_date"] as String,
      childName: json["child_name"] as String,
    );
  }
}

