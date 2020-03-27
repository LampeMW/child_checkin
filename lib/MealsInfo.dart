class MealsInfo {
  final String childId;
  final String none;
  final String some;
  final String most;
  final String all;
  final String childName; 
  final String what; 
  final String mealTime; 
  
  MealsInfo({this.childId, this.childName, this.none, this.some, this.most, this.all, this.mealTime, this.what});

  factory MealsInfo.fromJson(Map<String, dynamic> json) 
  {
    return MealsInfo(
      childId: json['child_id'] as String,
      childName: json["child_name"] as String,
      none: json["noneEaten"] as String,
      some: json["someEaten"] as String,
      most: json["mostEaten"] as String,
      all: json["allEaten"] as String,
      what: json["what"] as String,
      mealTime: json["meal_time"] as String,
    );
  }
}

