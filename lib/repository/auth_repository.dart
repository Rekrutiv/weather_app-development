import 'dart:async';

import 'package:weather_app/models/auth/unauthorized_user_model.dart';
import 'package:weather_app/models/auth/user_model.dart';
import 'package:weather_app/service/auth/auth_service.dart';

class AuthRepository {
  AuthRepository({
    required AuthService googleSignInService,
  }) {
    _googleSignInService = googleSignInService;
    _googleSignInService.userModelStream.listen((user) {
      _currentUser = user;
      _userModelStreamController.add(user);
    });
  }
  late final AuthService _googleSignInService;

  // ignore: prefer_final_fields
  UserModel _currentUser = UnauthorizedUserModel();

  UserModel get currentUser => _currentUser;

  final _userModelStreamController = StreamController<UserModel>();
  Stream<UserModel>? _userModelStream;
  Stream<UserModel> get userModelStream {
    return _userModelStream ??=
        _userModelStreamController.stream.asBroadcastStream();
  }

  Future<UserModel> googleSignIn() async {
    return await _googleSignInService.signIn();
  }

  Future<UserModel> googleSignOut() async {
    return await _googleSignInService.signOut();
  }
}
