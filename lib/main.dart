import 'package:fmpglobalinc/core/config/mapbox_config.dart';
import 'package:fmpglobalinc/core/config/routes.dart';
import 'package:fmpglobalinc/core/services/service_locator.dart';
import 'package:fmpglobalinc/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fmpglobalinc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fmpglobalinc/core/config/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  await setup();
  runApp(const MyApp());
}

Future setup() async {
  try {
    await dotenv.load(fileName: '.env');
    final token = MapboxConfig.accessToken;
    print("Loaded token: $token");
    MapboxOptions.setAccessToken(token);
    print("Token set successfully");
  } catch (e) {
    print("Error in setup: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>())],
      child: MaterialApp(
        title: 'fmpglobalinc',
        theme: AppTheme.theme,
        initialRoute: Routes.splash,
        routes: Routes.getRoutes(),
        onGenerateRoute: (settings) {
          return null;
        },
      ),
    );
  }
}
