import 'package:weather_app/models/auth/authorized_user_model.dart';

class GoogleUserModel extends AuthorizedUserModel {
  GoogleUserModel({
    required String id,
    required String? name,
  }) {
    _id = id;
    _name = name;
  }
  late final String _id;
  late final String? _name;

  @override
  String get id => _id;

  @override
  String? get name => _name;
}
