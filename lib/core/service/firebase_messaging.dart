import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:organization_pgp/core/core.dart';

import '../../features/auth/data/repository/auth_repository.dart';
import '../../firebase_options.dart';

class FirebaseMessagingService {
  static Future<bool> getToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance
          .getToken(
        vapidKey:
            'BBHCuZVQxMjFjB6VXueRDO_xOxyXfKNFnPkG3-nIwNH6RIPc8ilDMKPpZ_Mul1_U3eEyLtF_qzxqWU9EcBRh3C4 ',
      )
          .timeout(
        const Duration(seconds: 45),
        onTimeout: () {
          Helper.log('firebase get token error onTimeout');
          return null;
        },
      ).onError(
        (error, stackTrace) {
          Helper.log(error.toString());
          return null;
        },
      );

      Helper.log('fcmToken => $fcmToken');
      AppInfo.fcmToken = fcmToken ?? '';

      if (fcmToken?.isNotEmpty ?? false) {
        await authRepository.saveFireBaseToken(
          token: fcmToken ?? '',
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Helper.log('firebase get token error catch');
      Helper.log(e.toString());
      return false;
    }
  }

  static Future<void> initializeApp() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await FirebaseMessaging.instance.setAutoInitEnabled(true);
    } catch (e) {
      Helper.log('firebase error!');
    }
  }

  static onTokenRefresh() async {
    try {
      FirebaseMessaging.instance.onTokenRefresh.listen(
        (fcmToken) async {
          Helper.log('Refresh fcmToken => $fcmToken');
          AppInfo.fcmToken = fcmToken;

          try {
            await authRepository.saveFireBaseToken(
              token: fcmToken,
            );
          } catch (e) {
            Helper.log('firebase refresh token error on send to server ');
          }
        },
      ).onError(
        (err) {
          Helper.log('error on refresh fcm token ');
        },
      );
    } catch (e) {
      Helper.log('firebase refresh token error ');
    }
  }

  static Future<void> deleteToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          Helper.log('firebase get token error ');
        },
      );
    } catch (e) {
      Helper.log('firebase get token error ');
    }
  }
}
