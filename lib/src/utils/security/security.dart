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

  String obscure(String key, String token) {
    final $1 = key.substring(0, 8);
    final $2 = token
        .split('.')[2]
        .split('')
        .reversed
        .join()
        .substring(0, 27)
        .replaceAll(RegExp('[+-]'), '_');

    final $3 = key.substring(key.length - 9);

    return '${$1}${$2}${$3}';
  }

  @override
  Future<Map<String, dynamic>> getDTD({
    required String data,
    required String key,
    required String token,
  }) async {
    try {
      final dTk = await getDTK(key);

      final fullKey = Key.fromBase64(obscure(dTk, token));

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
