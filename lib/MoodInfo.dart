class MoodInfo {
  final String hyper;
  final String grumpy;
  final String sleepy; 
  final String happy;
  final String cranky; 
  final String childId; 
  final String utcDate; 
  final String childName; 

  
  MoodInfo({this.hyper, this.grumpy, this.sleepy, this.happy, this.cranky, this.childId, this.utcDate, this.childName});

  factory MoodInfo.fromJson(Map<String, dynamic> json) 
  {
    return MoodInfo(
      hyper: json['hyper'] as String,
      grumpy: json["grumpy"] as String,
      childId: json["child_id"] as String, 
      sleepy: json["sleepy"] as String,
      happy: json["happy"] as String, 
      cranky: json["cranky"] as String,
      utcDate: json["utcDate"] as String,
      childName: json["child_name"] as String
    );
  }
}

