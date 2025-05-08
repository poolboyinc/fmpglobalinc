import 'package:flutter/material.dart';

class SocialAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isGoogle;

  const SocialAuthButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isGoogle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isGoogle)
              Image.asset(
                'assets/google_logo.png',
                height: 24,
                width: 24,
              )
            else
              const Icon(
                Icons.apple,
                size: 24,
                color: Colors.black,
              ),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
