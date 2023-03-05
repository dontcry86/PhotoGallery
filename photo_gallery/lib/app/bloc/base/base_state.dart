import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

class BaseInitialState extends BaseState {}

class BaseLoadingState extends BaseState {}

abstract class BaseSuccessState<T> extends BaseState {
  final _timestamp = DateTime.now().millisecond;
  final T? result;

  BaseSuccessState({this.result});

  @override
  List<Object?> get props => [result, _timestamp];
}

class BaseErrorState extends BaseState {
  final _timestamp = DateTime.now().millisecond;
  final String? errorCode;
  final String? errorMessage;
  BaseErrorState({this.errorCode, this.errorMessage});

  @override
  List<Object?> get props => [errorCode, errorMessage, _timestamp];
}
