import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Skeleton-style loading placeholder, per the brief ("avoid excessive
/// circular loading indicators"). Used for dashboard cards/charts.
class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.height = 90, this.borderRadius = 18});

  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: const _ShimmerLine(),
    );
  }
}

class _ShimmerLine extends StatefulWidget {
  const _ShimmerLine();

  @override
  State<_ShimmerLine> createState() => _ShimmerLineState();
}

class _ShimmerLineState extends State<_ShimmerLine> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Opacity(
          opacity: 0.35 + (0.25 * (1 - (_controller.value - 0.5).abs() * 2)),
          child: Container(color: AppColors.divider),
        );
      },
    );
  }
}
