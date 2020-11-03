
/// Class that store users'personal information
class UserInfo {
  final String token;
  final double height;
  final double weight;
  final int age;
  /// Can be [0,1,2] -> [unknown, male, female]
  final int gender;
  final List<bool> posturalProblems;
  final bool problemsInFamily;
  final bool useOfDrugs;
  final bool alcoholIntake;
  final List<bool> otherTrauma;
  final List<bool> sightProblems;
  final int hearingProblems;

  UserInfo({
    this.token,
    this.height,
    this.weight,
    this.age,
    this.gender,
    this.posturalProblems,
    this.problemsInFamily,
    this.useOfDrugs,
    this.otherTrauma,
    this.sightProblems,
    this.hearingProblems,
    this.alcoholIntake,
  });

  /// Maps this object to json
  Map<String, dynamic> toJson() =>
      {
        'age': this.age,
        'height': this.height,
        'region': '',
        'gender': this.gender,
        'weight': this.weight,
        'injuries': this.posturalProblems,
        'inheritance': this.problemsInFamily,
        'medicines': this.useOfDrugs,
        'other': this.otherTrauma,
        'eyesight_problems': this.sightProblems,
        'hearing_problems': this.hearingProblems,
        'alcool': this.alcoholIntake,
      };

  @override
  String toString() => "UserInfo("
    "height=$height, "
    "age=$age, "
    "weight=$weight, "
    "gender=$gender, "
    "posturalProblems=$posturalProblems, "
    "problemsInFamily=$problemsInFamily, "
    "useOfDrugs=$useOfDrugs, "
    "alcool=$alcoholIntake, "
    "otherTrauma=$otherTrauma, "
    "sightProblems=$sightProblems, "
    "hearingProblems=$hearingProblems"
    ")";
}