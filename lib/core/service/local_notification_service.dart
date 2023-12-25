import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/helper.dart';

enum AppNotificationChannelType {
  pgp,
  meesage,
  competition,
  survey,
  event,
  meeting
}

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize({
    required BuildContext context,
  }) {
    var initializationSettingsAndroid = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var initializationSettingsIOS = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {
        Helper.log('payload: $payload');
        if (payload != null || payload != '') {
          Helper.log('notification payload: $payload');
          /*Navigator.pushNamed(context, payload);*/
        }
      },
    );

    notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        onSelectNotification(
          details,
          context,
        );
      },
      /*onDidReceiveBackgroundNotificationResponse: (details) {
        Helper.log('payload: ${details.payload}');
        if (details.payload != null || details.payload != '') {
          Helper.log('notification payload: ${details.payload}');
          Navigator.of(context).pushNamed(details.payload!);
        }
      },*/
    );
  }

  static Future showNotification({
    String? title,
    String? body,
    String? payload,
    String? imageUrl,
    String? channelId,
    required AppNotificationChannelType appNotificationChannelType,
  }) async {
    Helper.log('show notification: $title');
    try {
      int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      BigPictureStyleInformation? bigPictureStyleInformation;
      if (imageUrl != null) {
        try {
          final Response response = await Dio().get(
            imageUrl,
            options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              },
            ),
          );

          Helper.log('show Image');
          Helper.log(response.statusCode.toString());
          Helper.log(response.data.toString());
          Helper.log('end Image');

          if (response.data != null) {
            bigPictureStyleInformation = BigPictureStyleInformation(
              contentTitle: title,
              ByteArrayAndroidBitmap.fromBase64String(
                base64Encode(response.data),
              ),
              hideExpandedLargeIcon: true,
              /*largeIcon: ByteArrayAndroidBitmap.fromBase64String(
              base64Encode(response.data),
            ),*/
            );
          }
        } catch (e) {
          Helper.log('');
        }
      }

      Helper.log(bigPictureStyleInformation?.bigPicture.toString() ?? '');
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'PGP',
        'PGP channel.',
        channelDescription: 'This is our channel.',
        importance: Importance.max,
        icon: '@mipmap/ic_launcher',
        priority: Priority.high,
        styleInformation: bigPictureStyleInformation,
      );

      if (appNotificationChannelType == AppNotificationChannelType.survey) {
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'Survey',
          'Survey channel.',
          channelDescription: 'This is our channel.',
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigPictureStyleInformation,
        );
      } else if (appNotificationChannelType ==
          AppNotificationChannelType.meesage) {
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'Message',
          'Message channel.',
          channelDescription: 'This is our channel.',
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigPictureStyleInformation,
        );
      } else if (appNotificationChannelType ==
          AppNotificationChannelType.competition) {
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'Competition',
          'Competition channel.',
          channelDescription: 'This is our channel.',
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigPictureStyleInformation,
        );
      } else if (appNotificationChannelType ==
          AppNotificationChannelType.event) {
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'Events',
          'Events channel.',
          channelDescription: 'This is our channel.',
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigPictureStyleInformation,
        );
      } else if (appNotificationChannelType ==
          AppNotificationChannelType.meeting) {
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'Meeting',
          'Meeting channel.',
          channelDescription: 'This is our channel.',
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigPictureStyleInformation,
        );
      } else {
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'PGP',
          'PGP channel.',
          channelDescription: 'This is our channel.',
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigPictureStyleInformation,
        );
      }

      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );
      await notificationsPlugin.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
    } catch (e) {
      Helper.log(e.toString());
    }
  }

  static void onSelectNotification(
    NotificationResponse response,
    BuildContext context,
  ) async {
    String? str = response.payload;
    Map<String, dynamic> payload = jsonDecode(str ?? '');
    Helper.log('payload: $payload');
    if (payload['route'] != null || payload['route'] != '') {
      Helper.log('notification payload: $payload');

      Navigator.of(context).pushNamed(
        '/${payload['route']}',
        arguments: {
          'id': payload['id'],
        },
      );
    }
  }

  static AppNotificationChannelType getChannelFromString({
    required String? channelId,
  }) {
    if (channelId == AppNotificationChannelType.competition.name) {
      return AppNotificationChannelType.competition;
    } else if (channelId == AppNotificationChannelType.meesage.name) {
      return AppNotificationChannelType.meesage;
    } else if (channelId == AppNotificationChannelType.survey.name) {
      return AppNotificationChannelType.survey;
    } else if (channelId == AppNotificationChannelType.event.name) {
      return AppNotificationChannelType.event;
    } else if (channelId == AppNotificationChannelType.meeting.name) {
      return AppNotificationChannelType.meeting;
    } else {
      return AppNotificationChannelType.pgp;
    }
  }
}
