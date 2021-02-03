import 'package:equatable/equatable.dart';

abstract class OnBoardingState extends Equatable {
  const OnBoardingState();
}

class IdleState extends OnBoardingState {
  @override
  List<Object> get props => [];
}

class NeedToValidateState extends OnBoardingState {
  final int index;

  const NeedToValidateState(this.index);

  @override
  List<Object> get props => [index];
}

class ValidationSuccessState extends OnBoardingState {
  @override
  List<Object> get props => [];
}
