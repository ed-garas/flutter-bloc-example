import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterbloc/datamodels/user.dart';
import 'package:flutterbloc/repository/authentication_repository.dart';
import 'package:flutterbloc/services/locator.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final authenticationRepository = locator<AuthenticationRepository>();

  AuthenticationBloc() : super(UnknownState()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);

    _authenticationStatusSubscription = authenticationRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    authenticationRepository.dispose();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    print('HERE 2 ${DateTime.now()}');
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(UnauthenticatedState());
      case AuthenticationStatus.authenticated:
        emit(LoadingState());
        final user = await _tryGetUser();
        return emit(
          user != null
              ? AuthenticatedState(user: user)
              : UnauthenticatedState(),
        );
      case AuthenticationStatus.unknown:
        return emit(UnknownState());
    }
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    authenticationRepository.logout();
  }

  Future<User?> _tryGetUser() async {
    try {
      final user = await authenticationRepository.fetchUser();
      return user;
    } catch (_) {
      return null;
    }
  }
}
