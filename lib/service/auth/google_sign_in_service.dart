import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:weather_app/models/auth/google_user_model.dart';
import 'package:weather_app/models/auth/unauthorized_user_model.dart';
import 'package:weather_app/models/auth/user_model.dart';
import 'package:weather_app/service/auth/auth_service.dart';

class GoogleSignInService implements AuthService {
  GoogleSignInService() {
    _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    _subscribeToUserChange();
  }
  late final GoogleSignIn _googleSignIn;

  final StreamController<UserModel> _userModelStreamController =
      StreamController<UserModel>();

  Stream<UserModel>? _userModelStream;

  @override
  Stream<UserModel> get userModelStream {
    return _userModelStream ??=
        _userModelStreamController.stream.asBroadcastStream();
  }

  void _subscribeToUserChange() {
    _googleSignIn.onCurrentUserChanged.listen(
      (_) {
        _userModelStreamController.add(currentUser);
      },
    );
  }

  @override
  UserModel get currentUser {
    final account = _googleSignIn.currentUser;
    UserModel userModel = account == null
        ? UnauthorizedUserModel()
        : GoogleUserModel(
            id: account.id,
            name: account.displayName,
          );
    return userModel;
  }

  @override
  Future<UserModel> signIn() async {
    await _googleSignIn.signIn();
    return currentUser;
  }

  @override
  Future<UserModel> signOut() async {
    await _googleSignIn.signOut();
    return currentUser;
  }
}
