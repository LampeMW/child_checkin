class SuppliesInfo {
  final String diapers;
  final String spareClothes;
  final String childId; 
  final String utcDate; 
  final String childName; 

  
  SuppliesInfo({this.spareClothes, this.diapers, this.childId, this.utcDate, this.childName});

  factory SuppliesInfo.fromJson(Map<String, dynamic> json) 
  {
    return SuppliesInfo(
      diapers: json['diapers'] as String,
      spareClothes: json["spare_clothes"] as String,
      childId: json["child_id"] as String,
      utcDate: json["utcDate"] as String,
      childName: json["child_name"] as String
    );
  }
}

