import 'package:fmpglobalinc/core/config/theme.dart';
import 'package:fmpglobalinc/features/auth/presentation/widgets/auth_button.dart';
import 'package:fmpglobalinc/features/auth/presentation/widgets/custom_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fmpglobalinc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fmpglobalinc/features/auth/presentation/bloc/auth_event.dart';
import 'package:fmpglobalinc/features/auth/presentation/bloc/auth_state.dart';

import '../../../../core/config/routes.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is Authenticated) {
          Navigator.pushReplacementNamed(context, Routes.main);
          // Navigate to main app screen after successful authentication
          // TODO: Replace with your main screen route
          // Navigator.pushReplacementNamed(context, '/home');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                // Custom curved background
                CustomPaint(
                  size: Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height,
                  ),
                  painter: CurvedPainter(),
                ),
                if (state is AuthLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                // Content
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Image.asset('assets/logo_png_test_1.png', height: 225),
                        const SizedBox(height: 2),
                        Transform.translate(
                          offset: const Offset(0, -30),
                          child: const Text(
                            'FindMyParty',
                            style: TextStyle(
                              fontFamily: 'Coolvetica',
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(flex: 4),
                        Column(
                          children: [
                            SocialAuthButton(
                              text: 'Continue with Google',
                              isGoogle: true,
                              onPressed:
                                  state is AuthLoading
                                      ? () {} // Provide empty callback when loading
                                      : () {
                                        context.read<AuthBloc>().add(
                                          GoogleSignInRequested(),
                                        );
                                      },
                            ),
                            const SizedBox(height: 16),
                            SocialAuthButton(
                              text: 'Continue with Apple',
                              isGoogle: false,
                              onPressed: () {
                                // Implement Apple sign in
                              },
                            ),
                            const SizedBox(height: 16),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Divider(color: Colors.white54),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      'or',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: Colors.white54),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryPurple,
                                minimumSize: const Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            RichText(
                              text: TextSpan(
                                text: 'Have an account already? ',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Log in',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(
                                              context,
                                              '/login',
                                            );
                                          },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text:
                                    'By continuing you automatically accept our ',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer:
                                        TapGestureRecognizer()..onTap = () {},
                                  ),
                                  const TextSpan(text: ', '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer:
                                        TapGestureRecognizer()..onTap = () {},
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Cookies Policy',
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer:
                                        TapGestureRecognizer()..onTap = () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
