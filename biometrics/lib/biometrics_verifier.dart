import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricsVerifier {
  late LocalAuthentication auth;

  BiometricsVerifier() {
    auth = LocalAuthentication();
  }

  Future<void> _ableToAuthenticate() async {
    bool supported = await auth.canCheckBiometrics;
    bool entryExists = await auth.isDeviceSupported();
    if (!supported) throw "Device doesn't support Biometrics.";
    if (!entryExists) throw "Biometric entry not found in phone.";
  }

  Future<void> verifyBiometrics(String? prompt) async {
    await _ableToAuthenticate();
    late bool didAuthenticate;
    try {
      didAuthenticate = await auth.authenticate(
        localizedReason: prompt ?? 'Please authenticate with biometrics',
      //     这两个属性用于配置生物识别认证的行为：
      //
      // *   `stickyAuth`:
      // *   当设置为 `true` 时，如果身份验证对话框弹出后，您的应用转到后台，身份验证过程不会被取消。当应用返回前台时，对话框会重新出现。
      // *   这主要适用于 Android。
      //
      // *   `biometricOnly`:
      // *   当设置为 `true` 时，它强制只使用生物识别（如指纹或面部识别）进行身份验证。
      // *   如果设置为 `false`，当生物识别失败时，系统可能会允许用户回退到使用设备密码（PIN、图案或密码）进行验证。
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException {
      throw "Platform Exception : Biometrics Failed !";
    }
    if (!didAuthenticate) throw "Biometrics Failed";
  }
}
