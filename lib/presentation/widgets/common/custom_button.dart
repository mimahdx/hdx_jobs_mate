import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? color;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
      foregroundColor: color ?? Theme.of(context).colorScheme.primary,
      side: BorderSide(
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
    )
        : ElevatedButton.styleFrom(
      backgroundColor: color ?? Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
    );

    final child = isLoading
        ? const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon),
          const SizedBox(width: 8),
        ],
        Text(text),
      ],
    );

    return isOutlined
        ? OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: child,
    )
        : ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: child,
    );
  }
}