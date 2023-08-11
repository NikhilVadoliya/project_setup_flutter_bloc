import 'package:flutterprojectsetup/data/local/db/user/user_table.dart';
import 'package:flutterprojectsetup/data/local/share_preference/app_preference.dart';
import 'package:flutterprojectsetup/data/local/share_preference/preference_constant.dart';
import 'package:flutterprojectsetup/data/model/user.dart';

abstract class UserLocalRepository {
  Future<int> insertUserDB(UserLocalCompanion userCompanion);

  Future<void> insertListOfUserDB(List<User> user);

  Future<List<UserLocalData>> getUsersFromDB();

  Future<int> deleteUsersDB();

  Future<void> lastResponseTimeStamp(int timestamp);

  Future<int?> getLastUpdateResponseTimeStamp();
}

class UserLocalRepositoryImpl implements UserLocalRepository {
  UserLocalRepositoryImpl({
    required AppDatabase appDatabaseManager,
    required AppPreference appPreference,
  })  : _appDatabaseManager = appDatabaseManager,
        _appPreference = appPreference;

  late final AppDatabase _appDatabaseManager;
  late final AppPreference _appPreference;

  @override
  Future<int> insertUserDB(UserLocalCompanion userCompanion) async {
    return await _appDatabaseManager.insertUser(userCompanion);
  }

  @override
  Future<List<UserLocalData>> getUsersFromDB() async {
    return await _appDatabaseManager.getUserList();
  }

  @override
  Future<int> deleteUsersDB() async {
    return _appDatabaseManager.deleteUser();
  }

  @override
  Future<void> insertListOfUserDB(List<User> users) async {
    return await Future.forEach(users, (User user) async {
      await _appDatabaseManager.insertUser(UserLocalCompanion.insert(
          gender: user.gender, email: user.email, phone: user.phone, name: user.name.fullName));
    });
  }

  @override
  Future<void> lastResponseTimeStamp(int timeStamp) =>
      _appPreference.writeInt(PreferenceConstant.lastResponseTimeKey, timeStamp);

  @override
  Future<int?> getLastUpdateResponseTimeStamp() {
    return _appPreference.readInt(PreferenceConstant.lastResponseTimeKey);
  }
}
