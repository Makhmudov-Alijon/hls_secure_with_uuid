import 'package:encrypt/encrypt.dart';

import '../../download_manager.dart';

final class HlsEncrypter {
  HlsEncrypter._();

  static const randomKey =
      'NYxwDDWg4g6BWI4whCTIe3CfAUJ6aOlzj2j1SABX6DwKyh7HWCD5G1jHIhWPl0Dh';

  static String getHlsEncryptionKey(LocalHlsId id) {
    final key = randomKey.substring(0, 32);
    final hlsString = [
      id.contentId.toString(),
      if (id.filmId != null) id.filmId.toString(),
      if (id.seasonId != null) id.seasonId.toString(),
      if (id.episodeId != null) id.episodeId.toString(),
    ].join();
    return (key + hlsString).substring(0, 32);
  }

  static String encryptData({
    required LocalHlsId id,
    required String data,
  }) {
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
    required LocalHlsId id,
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
    required LocalHlsId id,
    required String iv,
    required String enc,
  }) {
    final key = getHlsEncryptionKey(id);
    final encrypter = Encrypter(
      AES(
        Key.fromUtf8(key),
        mode: AESMode.cbc,
      ),
    );
    final encrypted = encrypter.encrypt(enc, iv: IV.fromUtf8(iv));
    return encrypted.base64;
  }

  static String decryptEnc({
    required LocalHlsId id,
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
    );
  }
}
