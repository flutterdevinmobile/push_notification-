part of '../data.dart';

class HiveLocalSource {
  final Box _box;

  HiveLocalSource(this._box);

  Future<void> saveToken(String token) async {
    await _box.put('token', token);
  }

  String? getToken() {
    return _box.get('token');
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
