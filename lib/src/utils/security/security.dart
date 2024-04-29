import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Security {
  Future<String> getDTK(String key);

  Future<Map<String, dynamic>> getDTD({
    required String data,
    required String key,
    required String token,
  });
}

class SecurityService extends Security {
  @override
  Future<String> getDTK(String key) async {
    await dotenv.load();

    final result = dotenv.env[key];

    dotenv.clean();

    if (result == null) {
      throw Exception(
        'DTK variable not found. A non-null fallback is required for missing entries',
      );
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getDTD({
    required String data,
    required String key,
    required String token,
  }) async {
    try {
      final dTk = await getDTK(key);

      final thumbnail = dTk.split('').take(8).join();
      final salt = token
          .split('.')[1]
          .split('')
          .asMap()
          .entries
          .where((entry) => entry.key % 3 == 0)
          .map((entry) => entry.value)
          .take(35)
          .join();

      final fullKey = Key.fromBase64('$thumbnail$salt=');

      final encrypter = Encrypter(
        Fernet(fullKey),
      );

      final dectedData = encrypter.decrypt(
        Encrypted(
          base64.decode(data),
        ),
      );

      return jsonDecode(dectedData) as Map<String, dynamic>;
    } catch (err) {
      rethrow;
    }
  }
}
