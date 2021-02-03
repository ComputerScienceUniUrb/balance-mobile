import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingDataBloc extends Bloc<OnBoardingDataEvent, OnBoardingData> {
  @override
  OnBoardingData get initialState => OnBoardingData.empty();

  @override
  Stream<OnBoardingData> mapEventToState(OnBoardingDataEvent event) async* {
    if (event is ChangeHeight) {
      yield state.copyWith(height: event.height);
    }
  }
}

abstract class OnBoardingDataEvent extends Equatable {}

class ChangeHeight extends OnBoardingDataEvent {
  final int height;

  ChangeHeight(this.height);

  @override
  List<Object> get props => [];
}

class OnBoardingData extends Equatable {
  final int height;

  OnBoardingData({this.height});

  factory OnBoardingData.empty() {
    return OnBoardingData();
  }

  OnBoardingData copyWith({
    int height,
  }) {
    if ((height == null || identical(height, this.height))) {
      return this;
    }

    return new OnBoardingData(
      height: height ?? this.height,
    );
  }

  @override
  List<Object> get props => [height];
}
