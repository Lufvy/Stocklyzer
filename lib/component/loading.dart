import 'package:flutter/material.dart';

class OverlayLoading extends StatelessWidget {
  final bool isBackground;
  final double size;
  const OverlayLoading({
    super.key,
    this.isBackground = true, // default so existing code doesn't break
    this.size =
        double.infinity, // default size for the CircularProgressIndicator
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: isBackground
          ? Colors.black.withValues(alpha: 0.5)
          : Colors.transparent,
      child: Center(
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
