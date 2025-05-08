import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fmpglobalinc/core/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:fmpglobalinc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fmpglobalinc/features/auth/presentation/bloc/auth_event.dart';
import 'package:fmpglobalinc/features/auth/presentation/bloc/auth_state.dart';

import '../../../../core/config/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckRequested()); // ← dispatch the check
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushReplacementNamed(context, Routes.main);
        } else if (state is Unauthenticated) {
          Navigator.pushReplacementNamed(context, Routes.auth);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.splashScreenStart,
                AppTheme.splashScreenMiddle,
                AppTheme.splashScreenEnd,
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo_png_test_1.png', height: 500),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
