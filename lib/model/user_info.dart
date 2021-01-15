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
  final String medicines;
  final bool alcoholIntake;
  final int alcoholQuantity; // Can be 0,1,2,3,4 -> [no, occasional, with meals, everytime possible]
  final List<bool> physicalTrauma;
  final bool needGlasses;
  final List<bool> sightProblems;
  final int hearingProblems;
  final int hearingLoss; // Can be 0,1,2,3,4 -> [no, occasional, with meals, everytime possible]
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
    this.medicines,
    this.alcoholIntake,
    this.alcoholQuantity,
    this.physicalTrauma,
    this.needGlasses,
    this.sightProblems,
    this.hearingProblems,
    this.hearingLoss,
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
        'medicines': this.medicines,
        'alcool_intake': this.alcoholIntake,
        'alcool_quantity': this.alcoholQuantity,
        'trauma': this.physicalTrauma,
        'need_glasses': this.needGlasses,
        'eyesight_problems': this.sightProblems,
        'hearing_problems': this.hearingProblems,
        'hearing_loss': this.hearingLoss,
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
        "medicines=$medicines, "
        "alcool_intake=$alcoholIntake, "
        "alcool_quantity=$alcoholQuantity, "
        "trauma=$physicalTrauma, "
        "need_glasses=$needGlasses, "
        "eyesight_problems=$sightProblems, "
        "hearing_problems=$hearingProblems, "
        "hearing_loss=$hearingLoss"
      ")";
}