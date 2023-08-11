import 'package:flutterprojectsetup/data/local/db/user/user_table.dart';
import 'package:flutterprojectsetup/data/local/share_preference/app_preference.dart';
import 'package:flutterprojectsetup/data/model/user.dart';
import 'package:flutterprojectsetup/data/remote/api_provider.dart';
import 'package:flutterprojectsetup/data/repository/user/user_local_repository.dart';
import 'package:flutterprojectsetup/data/repository/user/user_remote_repository.dart';
import 'package:flutterprojectsetup/injector/injector.dart';

abstract class UserRepository {
  Future<List<User>> getRemoteUser();

  Future<void> addListOfUserInLocal(List<User> user);

  Future<List<User>> getUsersFromLocal();

  Future<int> deleteAllUsersFromLocal();

  Future<void> setLatestResponseTime(int timestamp);

  Future<int?> getLatestResponseTimeStamp();
}

class UserRepositoryImp extends UserRepository {
  late final UserLocalRepository userLocalRepository;
  late final UserRemoteRepository userRemoteRepository;

  UserRepositoryImp.init() {
    userLocalRepository = UserLocalRepositoryImpl(
        appPreference: Injector.instance.get<AppPreference>(),
        appDatabaseManager: Injector.instance.get<AppDatabase>());
    userRemoteRepository = UserRemoteRepositoryImp(Injector.instance.get<BaseApiProvider>());
  }

  @override
  Future<void> addListOfUserInLocal(List<User> user) async =>
      await userLocalRepository.insertListOfUserDB(user);

  @override
  Future<int> deleteAllUsersFromLocal() async => await userLocalRepository.deleteUsersDB();

  @override
  Future<int?> getLatestResponseTimeStamp() async =>
      await userLocalRepository.getLastUpdateResponseTimeStamp();

  @override
  Future<List<User>> getRemoteUser() async => await userRemoteRepository.getUserFromRemote();

  @override
  Future<List<User>> getUsersFromLocal() async {
    List<UserLocalData> localUser = await userLocalRepository.getUsersFromDB();
    return localUser
        .map((user) => User(
            name: Name.fromString(user.name),
            gender: user.gender,
            email: user.email,
            phone: user.phone))
        .toList();
  }

  @override
  Future<void> setLatestResponseTime(int timestamp) async =>
      await userLocalRepository.lastResponseTimeStamp(timestamp);
}
