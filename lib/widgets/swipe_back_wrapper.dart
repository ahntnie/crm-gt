import 'package:crm_gt/features/routes.dart';
import 'package:flutter/material.dart';

class SwipeBackWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback? onSwipeBack;
  final bool enableSwipeBack;

  const SwipeBackWrapper({
    super.key,
    required this.child,
    this.onSwipeBack,
    this.enableSwipeBack = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enableSwipeBack) return child;

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 0) {
          // Vuốt trái (swipe right) để quay về
          if (onSwipeBack != null) {
            onSwipeBack!();
          } else {
            AppNavigator.pop();
          }
        }
      },
      child: child,
    );
  }
}
