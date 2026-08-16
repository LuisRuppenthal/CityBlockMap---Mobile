import 'package:flutter/material.dart';

enum AppAlertType { error, success }

class AppAlert extends StatelessWidget {
  final String message;
  final AppAlertType type;

  const AppAlert({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    final isError = type == AppAlertType.error;
    final bgColor = isError ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4);
    final borderColor = isError
        ? const Color(0xFFFECACA)
        : const Color(0xFFBBF7D0);
    final textColor = isError
        ? const Color(0xFFDC2626)
        : const Color(0xFF16A34A);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
