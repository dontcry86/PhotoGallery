import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

class BaseInitialState extends BaseState {}

class BaseLoadingState extends BaseState {}

abstract class BaseSuccessState<T> extends BaseState {
  final T? result;

  const BaseSuccessState({this.result});

  @override
  List<Object?> get props => [result];
}

class BaseErrorState extends BaseState {
  final _timestamp = DateTime.now().millisecond;

  final String? errorMessage;
  BaseErrorState({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage, _timestamp];
}