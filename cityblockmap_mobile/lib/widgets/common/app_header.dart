import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cityblockmap_mobile/core/services/auth_service.dart';
import 'package:cityblockmap_mobile/core/theme/app_colors.dart';

class AppHeader extends StatefulWidget {
  const AppHeader({super.key});

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  final _authService = AuthService();
  final _menuController = MenuController();

  String _login = '';
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final login = await _authService.getLogin();
    final isAdmin = await _authService.isAdmin();
    if (mounted) {
      setState(() {
        _login = login;
        _isAdmin = isAdmin;
      });
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) context.go('/login');
  }

  void _goToSettings() {
    // Novamente, ainda não foi implementado
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      elevation: 1,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.gray300)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => context.go('/dashboard'),
              child: const Text(
                'CityBlockMap',
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            _buildUserMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserMenu() {
    return MenuAnchor(
      controller: _menuController,
      style: MenuStyle(
        backgroundColor: const WidgetStatePropertyAll(AppColors.white),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.gray300),
          ),
        ),
        elevation: const WidgetStatePropertyAll(4),
      ),
      menuChildren: [
        if (_isAdmin) ...[
          _buildMenuItem(
            label: '+ Novo Usuário',
            hoverColor: const Color(0xFF2926DC),
            onTap: () => context.push('/register'),
          ),
          _buildMenuItem(
            label: '+ Novo Bairro',
            hoverColor: const Color(0xFF2926DC),
            onTap: () => context.push('/neighborhood-register'),
          ),
          _buildMenuItem(
            label: '+ Nova Quadra',
            hoverColor: const Color(0xFF2926DC),
            onTap: () => context.push('/block-register'),
          ),
        ],
        _buildMenuItem(
          label: 'Configurações',
          hoverColor: const Color(0xFF3AAD1D),
          onTap: _goToSettings,
        ),
        _buildMenuItem(
          label: 'Sair',
          hoverColor: const Color(0xFFDC2626),
          onTap: _logout,
        ),
      ],
      builder: (context, controller, child) {
        return InkWell(
          borderRadius: BorderRadius.circular(AppColors.radius),
          onTap: () {
            controller.isOpen ? controller.close() : controller.open();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.gray300),
              borderRadius: BorderRadius.circular(AppColors.radius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _login,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray600,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: controller.isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    size: 16,
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required String label,
    required Color hoverColor,
    required VoidCallback onTap,
  }) {
    return MenuItemButton(
      onPressed: () {
        _menuController.close();
        onTap();
      },
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) return hoverColor;
          return const Color(0xFF374151);
        }),
        textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 13)),
        alignment: Alignment.centerLeft,
        minimumSize: const WidgetStatePropertyAll(Size(160, 40)),
      ),
      child: Text(label),
    );
  }
}
