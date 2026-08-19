import 'package:flutter/material.dart';
import 'package:cityblockmap_mobile/core/services/session_expired_service.dart';

class SessionExpiredBanner extends StatelessWidget {
  const SessionExpiredBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: SessionExpiredService.instance,
      builder: (context, _) {
        if (!SessionExpiredService.instance.visible) {
          return const SizedBox.shrink();
        }

        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Material(
            color: const Color(0xFFFEF2F2),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFFECACA))),
              ),
              child: const Text(
                '⚠️ Sua sessão expirou. Redirecionando para o login...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFDC2626),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
