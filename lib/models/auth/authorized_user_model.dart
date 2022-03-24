import 'package:equatable/equatable.dart';
import 'package:weather_app/models/auth/user_model.dart';

abstract class AuthorizedUserModel extends Equatable implements UserModel {
  String get id;
  String? get name;

  @override
  List<Object?> get props => [id];
}
