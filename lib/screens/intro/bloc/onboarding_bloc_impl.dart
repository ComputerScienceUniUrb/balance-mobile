
import 'package:balance_app/screens/intro/bloc/events/onboarding_events.dart';
import 'package:balance_app/screens/intro/bloc/states/onboarding_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvents, OnBoardingState> {
  @override
  OnBoardingState get initialState => IdleState();

  OnBoardingBloc._();
  factory OnBoardingBloc.create() => OnBoardingBloc._();

  @override
  Stream<OnBoardingState> mapEventToState(OnBoardingEvents event) async* {
    // Check if the event is for validation
    if (event is NeedToValidateEvent)
      yield NeedToValidateState(event.index);
    // Check if the event is for validation result
    else if (event is ValidationSuccessEvent)
      yield ValidationSuccessState();
  }
}