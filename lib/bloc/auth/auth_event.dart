part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignInWithGoogleEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class SignInWithFacebookEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class SignOutEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class UserChangedEvent extends AuthEvent {
  const UserChangedEvent(this.userModel);

  final UserModel userModel;

  @override
  List<Object?> get props => [userModel];
}
