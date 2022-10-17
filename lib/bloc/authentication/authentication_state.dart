part of 'authentication_bloc.dart';


abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class UnknownState extends AuthenticationState {}

class UnauthenticatedState extends AuthenticationState {}

class LoadingState extends AuthenticationState {}

class AuthenticatedState extends AuthenticationState {
  final User user;
  const AuthenticatedState({required this.user});

  @override
  List<Object> get props => [user];
}