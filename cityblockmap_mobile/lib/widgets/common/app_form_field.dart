import 'package:flutter/material.dart';
import 'package:cityblockmap_mobile/core/theme/app_colors.dart';

class AppFormLabel extends StatelessWidget {
  final String text;
  final String? hint;

  const AppFormLabel(this.text, {super.key, this.hint});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: AppColors.blue500,
        ),
        children: [
          if (hint != null)
            TextSpan(
              text: ' $hint',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
                letterSpacing: 0,
                color: AppColors.gray600,
              ),
            ),
        ],
      ),
    );
  }
}

class AppFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  const AppFormTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, color: AppColors.gray900),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.gray300),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.blue400, width: 1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
      ),
    );
  }
}
