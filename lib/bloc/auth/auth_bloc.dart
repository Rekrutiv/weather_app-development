import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/models/auth/authorized_user_model.dart';
import 'package:weather_app/models/auth/unauthorized_user_model.dart';
import 'package:weather_app/models/auth/user_model.dart';
import 'package:weather_app/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // ignore: prefer_final_fields
  UserModel _currentUserModel = UnauthorizedUserModel();

  AuthBloc({
    required AuthRepository authRepository,
  }) : super(UnauthorizedState()) {
    authRepository.userModelStream.listen((userModel) {
      add(UserChangedEvent(userModel));
    });

    on<UserChangedEvent>(
      (event, emit) async {
        _handleUserChange(userModel: event.userModel, emit: emit);
      },
    );

    on<SignInWithGoogleEvent>(
      (event, emit) async {
        emit(LoadingState());
        final user = await authRepository.googleSignIn();
        if (user is UnauthorizedUserModel) {
          emit(const SignInErrorState('GoogleSignIn failed'));
        }
      },
    );
    on<SignOutEvent>(
      (event, emit) async {
        emit(LoadingState());
        final user = await authRepository.googleSignOut();
        if (user is AuthorizedUserModel) {
          emit(const SignOutErrorState('SignOut failed'));
        }
      },
    );
  }

  void _handleUserChange({
    required UserModel userModel,
    required Emitter emit,
  }) {
    if (_isUserChangedToUnauthorizedUser(userModel)) {
      emit(LoggedOutState());
    } else if (_isAuthorizedUserChanged(userModel)) {
      emit(AuthorizedUserChangedState(userModel as AuthorizedUserModel));
    } else if (_isUserChangedToAuthorizedUser(userModel)) {
      emit(SignedInState(userModel as AuthorizedUserModel));
    } else {
      throw (const FormatException());
    }
  }

  bool _isUserChangedToUnauthorizedUser(UserModel userModel) {
    return userModel is UnauthorizedUserModel &&
        _currentUserModel is AuthorizedUserModel;
  }

  bool _isAuthorizedUserChanged(UserModel userModel) {
    return userModel is AuthorizedUserModel &&
        _currentUserModel is AuthorizedUserModel &&
        userModel != _currentUserModel;
  }

  bool _isUserChangedToAuthorizedUser(UserModel userModel) {
    return userModel is AuthorizedUserModel &&
        _currentUserModel is UnauthorizedUserModel;
  }
}
