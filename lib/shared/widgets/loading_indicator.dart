// lib/shared/widgets/loading_indicator.dart

import 'package:flutter/material.dart';
import 'package:fmpglobalinc/core/config/theme.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
      ),
    );
  }
}
