import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_text_field.dart';

class CustomCurrencyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool readOnly;
  final String symbol;

  const CustomCurrencyTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.symbol = '\$',
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      onChanged: onChanged,
      readOnly: readOnly,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      prefix: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          symbol,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

