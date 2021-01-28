/// Class that store users'personal information
class UserInfo {
  final String token;
  final int height;
  final int weight;
  final int age;
  final int gender; // Can be 0,1,2 -> [unknown, male, female]
  final String region;
  final List<bool> posturalProblems; // []
  final bool problemsInFamily;
  final bool useOfDrugs;
  final int alcoholIntake; // Can be 0,1,2,3,4 -> [no, occasional, with meals, everytime possible]
  final int sportsActivity; // Can be 0,1,2,3,4 -> [no, occasional, with meals, everytime possible]
  final List<bool> physicalTrauma;
  final bool visionLoss;
  final List<bool> visionProblems;
  final bool hearingLoss;
  final List<bool> hearingProblems; // Can be 0,1,2,3,4 -> [no, occasional, with meals, everytime possible]
  // TODO: Region

  UserInfo({
    this.token,
    this.height,
    this.weight,
    this.age,
    this.gender,
    this.region,
    this.posturalProblems,
    this.problemsInFamily,
    this.useOfDrugs,
    this.alcoholIntake,
    this.sportsActivity,
    this.physicalTrauma,
    this.visionLoss,
    this.visionProblems,
    this.hearingLoss,
    this.hearingProblems,
  });

  /// Maps this object to json
  Map<String, dynamic> toJson() =>
      {
        'token': this.token,
        'height': this.height,
        'weight': this.weight,
        'age': this.age,
        'gender': this.gender,
        'region': '',
        'injuries': this.posturalProblems,
        'inheritance': this.problemsInFamily,
        'use_of_drugs': this.useOfDrugs,
        'alcool_intake': this.alcoholIntake,
        'sports_activity': this.sportsActivity,
        'trauma': this.physicalTrauma,
        'vision_loss': this.visionLoss,
        'vision_problems': this.visionProblems,
        'hearing_loss': this.hearingLoss,
        'hearing_problems': this.hearingProblems,
      };

  @override
  String toString() =>
      "UserInfo("
        "token=$token, "
        "height=$height, "
        "weight=$weight, "
        "age=$age, "
        "gender=$gender, "
        "region='', "
        "injuries=$posturalProblems, "
        "inheritance=$problemsInFamily, "
        "use_of_drugs=$useOfDrugs, "
        "alcool_intake=$alcoholIntake, "
        "sports_activity=$sportsActivity, "
        "trauma=$physicalTrauma, "
        "vision_loss=$visionLoss, "
        "vision_problems=$visionProblems, "
        "hearing_loss=$hearingLoss, "
        "hearing_problems=$hearingProblems"
      ")";
}