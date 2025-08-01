// presentation/shared/widgets/custom_text_field.dart

import 'package:flutter/material.dart';

/// Widget reutilizável para campos de entrada
class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          maxLines: maxLines,
          maxLength: maxLength,
          enabled: enabled,
          readOnly: readOnly,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(suffixIcon),
                    onPressed: onSuffixIconPressed,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.red[300]!,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.red[500]!,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: enabled ? const Color(0xFF1a1a1a) : Colors.grey[800],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget para campos numéricos
class NumberTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final int? min;
  final int? max;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;

  const NumberTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.min,
    this.max,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      hint: hint,
      initialValue: initialValue,
      controller: controller,
      keyboardType: TextInputType.number,
      prefixIcon: Icons.numbers,
      validator: validator ?? _defaultValidator,
      onChanged: onChanged,
      enabled: enabled,
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Campo opcional
    }

    final number = int.tryParse(value);
    if (number == null) {
      return 'Digite um número válido';
    }

    if (min != null && number < min!) {
      return 'Valor mínimo é $min';
    }

    if (max != null && number > max!) {
      return 'Valor máximo é $max';
    }

    return null;
  }
}

/// Widget para campos de texto com contador
class CounterTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final int maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;

  const CounterTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    required this.maxLength,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      hint: hint,
      initialValue: initialValue,
      controller: controller,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
    );
  }
}
