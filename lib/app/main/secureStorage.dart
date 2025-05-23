import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Securestorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  writeSecureData(String key, String value) async {
    await storage.write(key: key, value: value);
    final data = await storage.readAll();
    // print('qqqqqqq1 $data');
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

  printAllSecureData() async {
    final data = await storage.readAll();
    print('qqqqqqq2 $data');
  }
}
