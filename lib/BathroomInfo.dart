class BathroomInfo {
  final String none;
  final String some;
  final String bm; 
  final String triedPotty;
  final String potty; 
  final String childId; 
  final String utcDate; 
  final String childName; 

  
  BathroomInfo({this.none, this.some, this.bm, this.triedPotty, this.potty, this.childId, this.utcDate, this.childName});

  factory BathroomInfo.fromJson(Map<String, dynamic> json) 
  {
    return BathroomInfo(
      none: json['none'] as String,
      some: json["some"] as String,
      triedPotty: json["triedpotty"] as String, 
      potty: json["potty"] as String,
      bm: json["bm"] as String, 
      childId: json["child_id"] as String,
      utcDate: json["utcDate"] as String,
      childName: json["child_name"] as String,
    );
  }
}

