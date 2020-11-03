
abstract class OnBoardingEvents {
  const OnBoardingEvents();
}

class NeedToValidateEvent extends OnBoardingEvents {
  final int index;

  const NeedToValidateEvent(this.index);
}
class ValidationSuccessEvent extends OnBoardingEvents {}