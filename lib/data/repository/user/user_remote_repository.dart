import 'package:flutterprojectsetup/core/app_string.dart';
import 'package:flutterprojectsetup/data/model/user.dart';
import 'package:flutterprojectsetup/data/model/user_response.dart';
import 'package:flutterprojectsetup/data/remote/api_provider.dart';
import 'package:dio/dio.dart';

abstract class UserRemoteRepository {
  Future<List<User>> getUserFromRemote();
}

class UserRemoteRepositoryImp implements UserRemoteRepository {
  final BaseApiProvider baseApiProvider;

  UserRemoteRepositoryImp(this.baseApiProvider);

  @override
  Future<List<User>> getUserFromRemote() async {
    Response response = await baseApiProvider.getMethod('?results=10');
    if (response.statusCode == 200) {
      return Future.value(UserResponse.fromJson(response.data['results']).results);
    } else {
      throw Exception(somethingWentWrong);
    }
  }
}
