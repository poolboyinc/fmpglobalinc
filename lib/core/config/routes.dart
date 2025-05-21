import 'package:flutter/material.dart';
import 'package:fmpglobalinc/features/auth/presentation/pages/auth_page.dart';
import 'package:fmpglobalinc/features/auth/presentation/pages/calendar_page.dart';
import 'package:fmpglobalinc/features/auth/presentation/pages/login_page.dart';
import 'package:fmpglobalinc/features/auth/presentation/pages/parties_page.dart';
import 'package:fmpglobalinc/features/auth/presentation/pages/signup_page.dart';
import 'package:fmpglobalinc/features/auth/presentation/pages/splash_page.dart';
import 'package:fmpglobalinc/features/navigation/presentation/pages/main_scaffold.dart';

class Routes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';
  static const String map = '/map';
  static const String parties = '/parties';
  static const String calendar = '/calendar';
  static const String profile = '/profile';
  static const String menu = '/menu';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      auth: (context) => const AuthScreen(),
      login: (context) => const LoginScreen(),
      signup: (context) => const SignUpScreen(),
      main: (context) => const MainScaffold(),
      //map: (context) => const MapPage(),
      parties: (context) => const PartiesPage(),
      calendar: (context) => const CalendarPage(),
      //profile: (context) => const ProfilePage(),
      //menu: (context) => const MenuPage(),
    };
  }
}
