import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingDataBloc extends Bloc<OnBoardingDataEvent, OnBoardingData> {
  @override
  OnBoardingData get initialState => OnBoardingData.empty();

  @override
  Stream<OnBoardingData> mapEventToState(OnBoardingDataEvent event) async* {
    if (event is acceptConsent) {
      yield state.copyWith(consent_1: event.consent_1,consent_2: event.consent_2,consent_3: event.consent_3);
    }
    if (event is acceptHeight) {
      yield state.copyWith(height: event.height);
    }
    if (event is acceptInfo) {
      yield state.copyWith(age: event.age,gender: event.gender,weight: event.weight);
    }
    if (event is acceptPosture) {
      yield state.copyWith(
          postureCondition: event.postureCondition,
          posturalProblems: event.posturalProblems,
          problemsInFamily: event.problemsInFamily,
          previousTrauma: event.previousTrauma,
          traumas: event.traumas
      );
    }
    if (event is acceptHabits) {
      yield state.copyWith(
          useOfDrugs: event.useOfDrugs,
      );
    }
    if (event is acceptSight) {
      yield state.copyWith(
        hearingLoss: event.hearingLoss,
        hearingProblems: event.hearingProblems,
        visionLoss: event.visionLoss,
        visionProblems: event.visionProblems,
      );
    }
  }
}

abstract class OnBoardingDataEvent extends Equatable {}

class acceptConsent extends OnBoardingDataEvent {
  final bool consent_1;
  final bool consent_2;
  final bool consent_3;

  acceptConsent({this.consent_1,this.consent_2,this.consent_3});

  @override
  List<Object> get props => [];
}

class acceptHeight extends OnBoardingDataEvent {
  final String height;

  acceptHeight({this.height});

  @override
  List<Object> get props => [];
}

class acceptInfo extends OnBoardingDataEvent {
  final String age;
  final int gender;
  final String weight;

  acceptInfo({this.age,this.gender,this.weight});

  @override
  List<Object> get props => [];
}

class acceptPosture extends OnBoardingDataEvent {
  final int postureCondition;
  final List<bool> posturalProblems;
  final int problemsInFamily;
  final int previousTrauma;
  final List<bool> traumas;

  acceptPosture({this.postureCondition,this.posturalProblems,this.problemsInFamily,this.previousTrauma,this.traumas});

  @override
  List<Object> get props => [];
}

class acceptHabits extends OnBoardingDataEvent {
  final int useOfDrugs;

  acceptHabits({this.useOfDrugs});

  @override
  List<Object> get props => [];
}

class acceptSight extends OnBoardingDataEvent {
  final int hearingLoss;
  final List<bool> hearingProblems;
  final int visionLoss;
  final List<bool> visionProblems;

  acceptSight({this.hearingLoss,this.hearingProblems,this.visionLoss,this.visionProblems});

  @override
  List<Object> get props => [];
}

class OnBoardingData extends Equatable {
  final bool consent_1;
  final bool consent_2;
  final bool consent_3;
  final String height;
  final String age;
  final int gender;
  final String weight;
  final int postureCondition;
  final List<bool> posturalProblems;
  final int problemsInFamily;
  final int previousTrauma;
  final List<bool> traumas;
  final int useOfDrugs;
  final int hearingLoss;
  final List<bool> hearingProblems;
  final int visionLoss;
  final List<bool> visionProblems;

  OnBoardingData({
    this.consent_1,
    this.consent_2,
    this.consent_3,
    this.height,
    this.age,
    this.gender,
    this.weight,
    this.postureCondition,
    this.posturalProblems,
    this.problemsInFamily,
    this.previousTrauma,
    this.traumas,
    this.useOfDrugs,
    this.hearingLoss,
    this.hearingProblems,
    this.visionLoss,
    this.visionProblems,
  });

  factory OnBoardingData.empty() {
    return OnBoardingData();
  }

  OnBoardingData copyWith({
    bool consent_1,bool consent_2,bool consent_3,
    String height,
    String age,int gender,String weight,
    int postureCondition,List<bool> posturalProblems,int problemsInFamily,int previousTrauma,List<bool> traumas,
    int useOfDrugs,
    int hearingLoss,List<bool> hearingProblems,int visionLoss,List<bool> visionProblems,
  }) {
    return new OnBoardingData(
      consent_1: consent_1 ?? this.consent_1,
      consent_2: consent_2 ?? this.consent_2,
      consent_3: consent_3 ?? this.consent_3,
      height: height ?? this.height,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      postureCondition: postureCondition ?? this.postureCondition,
      posturalProblems: posturalProblems ?? this.posturalProblems,
      problemsInFamily: problemsInFamily ?? this.problemsInFamily,
      previousTrauma: previousTrauma ?? this.previousTrauma,
      traumas: traumas ?? this.traumas,
      useOfDrugs: useOfDrugs ?? this.useOfDrugs,
      hearingLoss: hearingLoss ?? this.hearingLoss,
      hearingProblems: hearingProblems ?? this.hearingProblems,
      visionLoss: visionLoss ?? this.visionLoss,
      visionProblems: visionProblems ?? this.visionProblems,
    );
  }

  isButtonEnabled (index) {
    switch (index) {
      case 1:
        return (consent_1 == true && consent_2 == true  && consent_3 == true) ? true : false;
      case 2:
        return (height != null && height.length > 0) ? true : false;
      case 3:
        return ((age != null && age.length > 0) &&
                 gender != null &&
                (weight != null && weight.length > 0)) ? true : false;
      case 4:
        return (problemsInFamily != null && postureCondition != null && previousTrauma != null) ? true : false;
      case 5:
        return (useOfDrugs != null) ? true : false;
      case 6:
        return (hearingLoss != null && visionLoss != null) ? true : false;

      default:
        return true;
    }
  }

  @override
  List<Object> get props => [
    consent_1,consent_2,consent_3,
    height,
    age,gender,weight,
    postureCondition,posturalProblems,problemsInFamily,previousTrauma,traumas,
    useOfDrugs,
    hearingLoss,hearingProblems,visionLoss,visionProblems,
  ];
}
