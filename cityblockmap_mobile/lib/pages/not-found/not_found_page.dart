import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cityblockmap_mobile/core/services/auth_service.dart';
import 'package:cityblockmap_mobile/core/theme/app_colors.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  Future<void> _goBack(BuildContext context) async {
    final authService = AuthService();
    final isAuthenticated = await authService.isAuthenticated();

    if (!context.mounted) return;

    if (isAuthenticated) {
      context.go('/blocks');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 56),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.gray300),
                borderRadius: BorderRadius.circular(AppColors.radius),
                boxShadow: AppColors.shadowLg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '404',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue500,
                      letterSpacing: -2,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Página não encontrada',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'A rota que você tentou acessar não existe.',
                    style: TextStyle(fontSize: 14, color: AppColors.gray600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => _goBack(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue500,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Voltar',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
