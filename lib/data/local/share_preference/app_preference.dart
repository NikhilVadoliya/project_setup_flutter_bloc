import 'dart:async';

import 'package:flutterprojectsetup/core/extension.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AppPreference {
  FutureOr<bool?> readBool(String key);

  Future<int?> readInt(String key);

  Future<String?> readString(String key);

  Future<void> writeBool(String key, bool value);

  Future<void> writeInt(String key, int value);

  Future<void> writeString(String key, String value);

  FutureOr<void> init();
}

class AppPreferenceImp implements AppPreference {
  late final FlutterSecureStorage _pref;

  final String lastResponseTimeKey = 'keyLastResponse';

  AppPreferenceImp() {
    init();
  }

  @override
  Future<bool?> readBool(key) async {
    String? value = await _pref.read(key: key);
    return value?.parseBool();
  }

  @override
  Future<int?> readInt(key) async {
    String? value = await _pref.read(key: key);
    return value != null ? int.tryParse(value) : null;
  }

  @override
  Future<String?> readString(key) {
    return _pref.read(key: key);
  }

  @override
  Future<void> writeBool(String key, bool value) async =>
      await _pref.write(key: key, value: value.toString());

  @override
  Future<void> writeInt(String key, int value) async =>
      await _pref.write(key: key, value: value.toString());

  @override
  Future<void> writeString(String key, String value) async =>
      await _pref.write(key: key, value: value.toString());

  @override
  FutureOr<void> init() {
    _pref = const FlutterSecureStorage(
        aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
            storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding));
  }
}
