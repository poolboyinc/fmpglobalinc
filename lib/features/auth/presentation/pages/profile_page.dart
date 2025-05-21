import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fmpglobalinc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fmpglobalinc/features/auth/presentation/bloc/auth_event.dart';
import 'package:fmpglobalinc/features/auth/presentation/bloc/auth_state.dart';
import 'package:fmpglobalinc/features/auth/presentation/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  final void Function(int index) onNavigateToTab;

  const ProfilePage({Key? key, required this.onNavigateToTab})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            body: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF9C3FE4), Color(0xFF7000FF)],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Hero(
                      tag: 'profile_image',
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          image: DecorationImage(
                            image: NetworkImage(
                              state.user.photoUrl ??
                                  'https://ui-avatars.com/api/?name=${state.user.name}&background=random',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      state.user.name ?? 'User',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 30,
                            top: 50,
                            child: FloatingBubbleButton(
                              title: 'Party History',
                              icon: Icons.history,
                              onTap: () {},
                            ),
                          ),
                          Positioned(
                            right: 40,
                            top: 120,
                            child: FloatingBubbleButton(
                              title: 'Upcoming Parties',
                              icon: Icons.calendar_today,
                              onTap: () {},
                            ),
                          ),
                          Positioned(
                            left: 60,
                            top: 220,
                            child: FloatingBubbleButton(
                              title: 'Edit Profile',
                              icon: Icons.edit,
                              onTap: () {},
                            ),
                          ),
                          Positioned(
                            right: 30,
                            bottom: 30,
                            child: FloatingBubbleButton(
                              title: 'Sign Out',
                              icon: Icons.logout,
                              onTap: () {
                                context.read<AuthBloc>().add(
                                  SignOutRequested(),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state is Unauthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          });
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class FloatingBubbleButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const FloatingBubbleButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  State<FloatingBubbleButton> createState() => _FloatingBubbleButtonState();
}

class _FloatingBubbleButtonState extends State<FloatingBubbleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => setState(() => isPressed = true),
            onTapUp: (_) => setState(() => isPressed = false),
            onTapCancel: () => setState(() => isPressed = false),
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color:
                    isPressed
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, color: Colors.white, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
