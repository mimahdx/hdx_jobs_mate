import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final Color? backgroundColor;
  final Color? progressColor;
  final String? message;

  const LoadingOverlay({
    super.key,
    this.backgroundColor,
    this.progressColor,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Semi-transparent background
        Positioned.fill(
          child: Container(
            color: backgroundColor ?? Colors.black54,
          ),
        ),
        // Centered loading indicator
        Center(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressColor ?? Theme.of(context).primaryColor,
                  ),
                ),
                if (message != null) ...[
                  const SizedBox(height: 16.0),
                  Text(
                    message!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}