import 'package:weather_app/models/auth/user_model.dart';

abstract class AuthService {
  Future<UserModel> signIn();

  Future<UserModel> signOut();

  UserModel get currentUser;

  Stream<UserModel> get userModelStream;
}
