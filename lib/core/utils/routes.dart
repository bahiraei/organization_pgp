import 'package:flutter/material.dart';

import '../../features/auth/data/model/app_version.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/verify_screen.dart';
import '../../features/fish/presentation/fish_screen.dart';
import '../../features/hokm/presentation/hokm_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/messages/presentation/screen/admin_edit_message_screen.dart';
import '../../features/messages/presentation/screen/admin_message_detail_screen.dart';
import '../../features/messages/presentation/screen/admin_message_list_screen.dart';
import '../../features/messages/presentation/screen/admin_message_screen.dart';
import '../../features/messages/presentation/screen/message_detail_screen.dart';
import '../../features/messages/presentation/screen/message_screen.dart';
import '../../features/pdf/pdf_screen.dart';
import '../../features/phone_book/data/model/phone_book_model.dart';
import '../../features/phone_book/presentation/phone_book_details_screen.dart';
import '../../features/phone_book/presentation/phone_book_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/splash/presentation/splash.dart';
import '../../features/update/update_screen.dart';

class Routes {
  static final Routes _instance = Routes._internal();

  factory Routes() => _instance;

  Routes._internal();

  static const String splash = "/splash";
  static const String login = "/login";
  static const String verify = "/verify";
  static const String update = "/update";
  static const String home = "/home";
  static const String message = "/message";
  static const String messageDetails = "/messageDetails";
  static const String phoneBook = "/phoneBook";
  static const String phoneBookDetails = "/phoneBookDetails";
  static const String fish = "/fish";
  static const String pdf = "/pdf";
  static const String profile = "/profile";
  static const String createMessage = "/createMessage";
  static const String createMessageList = "/createMessageList";
  static const String createMessageDetailsList = "/createMessageDetailsList";
  static const String adminEditMessageScreen = "/adminEditMessageScreen";
  static const String hokm = "/hokm";

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return screenRouting(const SplashScreen());

      case login:
        return screenRouting(
          LoginScreen(
            screenParams: settings.arguments as LoginScreenParams?,
          ),
        );

      case verify:
        return screenRouting(
          VerifyScreen(
            screenParams: settings.arguments as VerifyScreenParams,
          ),
        );

      case update:
        return screenRouting(
          UpdateScreen(
            appVersion: settings.arguments as AppVersion,
          ),
        );

      case home:
        return screenRouting(
          HomeScreen(
            screenParams: (settings.arguments ?? const HomeScreenParams())
                as HomeScreenParams,
          ),
        );

      case message:
        return screenRouting(
          MessageScreen(
            id: (settings.arguments as Map?)?['id'],
          ),
        );

      case messageDetails:
        return screenRouting(
          MessageDetailScreen(
            screenParams: settings.arguments as MessageDetailScreenParams,
          ),
        );

      case phoneBook:
        return screenRouting(const PhoneBookScreen());

      case phoneBookDetails:
        return screenRouting(
          PhoneBookDetailsScreen(
            phone: settings.arguments as Phone,
          ),
        );

      case fish:
        return screenRouting(
          const FishScreen(),
        );

      case pdf:
        return screenRouting(
          PdfScreen(
            params: settings.arguments as PdfScreenParams,
          ),
        );

      case profile:
        return screenRouting(
          const ProfileScreen(),
        );

      case createMessage:
        return screenRouting(
          const AdminMessageScreen(),
        );

      case createMessageList:
        return screenRouting(
          const AdminMessageListScreen(),
        );

      case createMessageDetailsList:
        return screenRouting(
          AdminMessageDetailScreen(
            screenParams: settings.arguments as AdminMessageDetailScreenParams,
          ),
        );

      case adminEditMessageScreen:
        return screenRouting(
          AdminEditMessageScreen(
            param: settings.arguments as AdminEditMessageParam,
          ),
        );

      case hokm:
        return screenRouting(
          const HokmScreen(),
        );

      default:
        return screenRouting(
          const Scaffold(
            body: Center(
              child: Text('404'),
            ),
          ),
        );
    }
  }

  MaterialPageRoute screenRouting(Widget screen) {
    return MaterialPageRoute(
      builder: (context) => screen,
    );
  }
}
