import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../download_manager.dart';

final class HlsEncrypterHeaders {
  HlsEncrypterHeaders._();
  static final xHeader = Platform.isLinux ? 'Cookie' : 'X-Key';

  static const tizenHeader = 'Cookie';

  static const androidHeader = 'X-Key';
}

final class HlsEncrypter {
  HlsEncrypter._();

  static bool _useEncrypt = true;

  static set useEncrypt(bool encrypt) {
    if (kDebugMode) {
      _useEncrypt = encrypt;
    }
  }

  static bool get useEncrypt => _useEncrypt;

  static const randomKey = 'irKpwxm49X810zMBMvKXRXIaqIzsJ73S';

  static const hlsDataDotEnvKey = 'API_DT_KY';

  static Future<Map<String, dynamic>> getDecryptedHlsData({
    required String data,
    required String access,
  }) async {
    await dotenv.load();
    const dotEnvKey = hlsDataDotEnvKey;
    final sKey = dotenv.env[dotEnvKey];
    if (sKey == null) {
      throw const FormatException(
        'DotEnv not found: $dotEnvKey',
      );
    }

    final reversedTokenPart = access.split('.')[2].split('').reversed.join();
    var keyStr = sKey.substring(0, 8) +
        reversedTokenPart.substring(0, 27) +
        sKey.substring(sKey.length - 9);
    keyStr = keyStr.replaceAll(RegExp('[+-]'), '_').substring(0, 32);

    final keyUtf = Key.fromUtf8(keyStr);
    final enc = Encrypter(AES(keyUtf, mode: AESMode.ecb));

    final encryptedBytes = base64.decode(data);
    final dec = enc.decrypt(Encrypted(encryptedBytes));

    final json = jsonDecode(dec) as Map<String, dynamic>;
    return json;
  }

  static String getJwt(HlsId id) {
    final signKey = getHlsEncryptionKey(id);
    final jwt = JWT(switch (id) {
      LocalHlsId _ => {
          'contentId': id.contentId.toString(),
          'seasonId': id.seasonId?.toString(),
          'episodeId': id.episodeId?.toString(),
          'filmId': id.filmId?.toString(),
          'date': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      MiniDramaHlsId _ => {
          'minidrama_id': id.minidramaId.toString(),
          'season_id': id.seasonId.toString(),
          'episode_id': id.episodeId.toString(),
          'date': DateTime.now().millisecondsSinceEpoch.toString(),
        },
    });
    final token = jwt.sign(SecretKey(signKey));
    return token;
  }

  static bool verifyJwt(HlsId id, String token) {
    final signKey = getHlsEncryptionKey(id);

    final jwt = JWT.tryVerify(
      token,
      SecretKey(signKey),
    );
    return jwt != null;
  }

  static String getHlsEncryptionKey(HlsId id) {
    // TODO: ask Igor for enc
    final key = randomKey.substring(0, 16);
    final hlsString = switch (id) {
      LocalHlsId _ => [
          id.contentId,
          if (id.filmId != null) id.filmId,
          if (id.seasonId != null) id.seasonId,
          if (id.episodeId != null) id.episodeId,
        ].join(),
      MiniDramaHlsId _ => [
          id.minidramaId,
          id.seasonId,
          id.episodeId,
        ].join(''),
    };
    return (key + hlsString).substring(0, 16);
  }

  static String encryptData({
    required HlsId id,
    required String data,
  }) {
    if (!useEncrypt) {
      return data;
    }
    final key = getHlsEncryptionKey(id);
    final encrypter = Encrypter(
      AES(
        Key.fromUtf8(key),
        mode: AESMode.ecb,
      ),
    );
    final encrypted = encrypter.encrypt(data);
    return encrypted.base64;
  }

  static String decryptData({
    required HlsId id,
    required String base64String,
  }) {
    final key = getHlsEncryptionKey(id);
    final encrypter = Encrypter(
      AES(
        Key.fromUtf8(key),
        mode: AESMode.ecb,
      ),
    );
    return encrypter.decrypt(
      Encrypted.fromBase64(
        base64String,
      ),
    );
  }

  static String encryptEncKey({
    required HlsId id,
    required String iv,
    required String enc,
  }) {
    if (!useEncrypt) {
      return enc;
    }
    final key = getHlsEncryptionKey(id);
    final encrypter = Encrypter(
      AES(
        Key.fromUtf8(key),
        mode: AESMode.cbc,
      ),
    );
    final encrypted =
        encrypter.encrypt(enc, iv: IV.fromBase16(iv.replaceFirst('0x', '')));
    return encrypted.base64;
  }

  static String decryptEnc({
    required HlsId id,
    required String encryptedEncKey,
    required String iv,
  }) {
    final key = getHlsEncryptionKey(id);
    final encrypter = Encrypter(
      AES(
        Key.fromUtf8(key),
        mode: AESMode.cbc,
      ),
    );
    return encrypter.decrypt(
      Encrypted.fromBase64(encryptedEncKey),
      iv: IV.fromBase16(iv.replaceFirst('0x', '')),
    );
  }

  static String? tryDecryptEnc({
    required HlsId id,
    required String encryptedEncKey,
    required String iv,
  }) {
    try {
      return decryptEnc(
        id: id,
        encryptedEncKey: encryptedEncKey,
        iv: iv,
      );
    } catch (e) {
      return null;
    }
  }
}
