
abstract class OnBoardingState {
  const OnBoardingState();
}

class IdleState extends OnBoardingState {}
class NeedToValidateState extends OnBoardingState {
  final int index;

  const NeedToValidateState(this.index);
}
class ValidationSuccessState extends OnBoardingState {}