class ParentNeedsInfo {
  final String childId; 
  final String utcDate; 
  final String childName; 
  final String item;
  final String status; 

  
  ParentNeedsInfo({this.item, this.childId, this.utcDate, this.childName, this.status});

  factory ParentNeedsInfo.fromJson(Map<String, dynamic> json) 
  {
    return ParentNeedsInfo(
      childId: json["child_id"] as String,
      utcDate: json["utc_date"] as String,
      childName: json["child_name"] as String,
      item: json["item"] as String,
      status: json["status"] as String
    );
  }
}

