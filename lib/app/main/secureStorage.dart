import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Securestorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  writeSecureData(String key, String value) async {
    await storage.write(key: key, value: value);
    print(storage);
  }

  readSecureData(String key) async {
    String value = await storage.read(key: key) ?? '';
    return value;
  }

  deleteSecureData(String key) async {
    await storage.delete(key: key);
  }

  deleteAllSecureData() async {
    await storage.deleteAll();
  }
}
