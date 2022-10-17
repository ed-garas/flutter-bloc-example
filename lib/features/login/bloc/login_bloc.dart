import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterbloc/repository/authentication_repository.dart';
import 'package:flutterbloc/services/locator.dart';
import 'package:formz/formz.dart';

import '../models/models.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final authenticationRepository = locator<AuthenticationRepository>();

  LoginBloc() : super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        status: Formz.validate([state.password, username]),
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([password, state.username]),
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        final user = await authenticationRepository.loginWithEmail(
            state.username.value,
            state.password.value
        );
        if (user != null) {
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        } else {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        }
      } catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
