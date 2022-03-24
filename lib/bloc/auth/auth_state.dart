part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class UnauthorizedState extends AuthState {
  @override
  List<Object> get props => [];
}

class SignedInState extends AuthState {
  const SignedInState(this.userModel);
  final AuthorizedUserModel userModel;

  @override
  List<Object> get props => [userModel];
}

class LoggedInState extends AuthState {
  const LoggedInState(this.userModel);
  final AuthorizedUserModel userModel;

  @override
  List<Object> get props => [userModel];
}

class SignInErrorState extends AuthState {
  const SignInErrorState(this.error);
  final String error;
  @override
  List<Object> get props => [error];
}

class SignOutErrorState extends AuthState {
  const SignOutErrorState(this.error);
  final String error;
  @override
  List<Object> get props => [error];
}

class AuthorizedUserChangedState extends AuthState {
  const AuthorizedUserChangedState(this.userModel);
  final AuthorizedUserModel userModel;

  @override
  List<Object> get props => [userModel];
}

class LoggedOutState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}
