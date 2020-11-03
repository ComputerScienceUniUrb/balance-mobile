
/// Class that store users'personal information
class UserInfo {
  final double height;
  final double weight;
  final int age;
  /// Can be [0,1,2] -> [unknown, male, female]
  final int gender;
  final List<bool> posturalProblems;
  final bool problemsInFamily;
  final bool useOfDrugs;
  final List<bool> otherTrauma;
  final List<bool> sightProblems;
  final int hearingProblems;

  UserInfo({
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
  });

  @override
  String toString() => "UserInfo("
    "height=$height, "
    "age=$age, "
    "weight=$weight, "
    "gender=$gender, "
    "posturalProblems=$posturalProblems, "
    "problemsInFamily=$problemsInFamily, "
    "useOfDrugs=$useOfDrugs, "
    "otherTrauma=$otherTrauma, "
    "sightProblems=$sightProblems, "
    "hearingProblems=$hearingProblems"
    ")";
}