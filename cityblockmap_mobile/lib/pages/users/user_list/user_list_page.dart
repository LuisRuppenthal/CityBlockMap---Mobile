import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cityblockmap_mobile/core/models/user_model.dart';
import 'package:cityblockmap_mobile/core/services/auth_service.dart';
import 'package:cityblockmap_mobile/core/services/user_service.dart';
import 'package:cityblockmap_mobile/core/theme/app_colors.dart';
import 'package:cityblockmap_mobile/widgets/modals/delete_confirm_dialog.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final _userService = UserService();
  final _authService = AuthService();

  List<User> _users = [];
  bool _loading = false;
  String? _errorMessage;
  String _currentLogin = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final currentLogin = await _authService.getLogin();
      final users = await _userService.getAll();

      if (mounted) {
        setState(() {
          _currentLogin = currentLogin;
          // Exclui o usuário atualmente logado da lista.
          _users = users.where((u) => u.login != currentLogin).toList();
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Erro ao carregar os usuários.');
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _goToUserEdit(int id) {
    context.push('/user-edit/$id');
  }

  Future<void> _openDeleteDialog(int id, String login) async {
    final confirmed = await DeleteConfirmDialog.show(
      context,
      title: 'Excluir usuário',
      message:
          'Tem certeza que deseja excluir o usuário "$login"? Essa ação não pode ser desfeita.',
    );

    if (confirmed) {
      try {
        await _userService.delete(id);
        await _loadUsers();
      } catch (_) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Erro ao excluir o usuário.';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadUsers,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gerenciar Usuários',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.blue900,
              ),
            ),
            const SizedBox(height: 8),
            Container(height: 4, width: 48, color: AppColors.blue500),
          ],
        ),
        ElevatedButton(
          onPressed: () => context.push('/register'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue500,
            foregroundColor: AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'Novo',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.blue500),
        ),
      );
    }

    if (_errorMessage != null) {
      return Text(
        _errorMessage!,
        style: const TextStyle(color: Color(0xFFDC2626), fontSize: 14),
      );
    }

    if (_users.isEmpty) {
      return const Text(
        'Nenhum outro usuário cadastrado.',
        style: TextStyle(color: AppColors.gray600, fontSize: 14),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = (constraints.maxWidth / 280).floor().clamp(1, 5);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _users.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 80,
          ),
          itemBuilder: (context, index) {
            return _buildUserCard(_users[index]);
          },
        );
      },
    );
  }

  Widget _buildUserCard(User user) {
    final isAdminUser = user.role == UserRole.admin;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.gray300),
        borderRadius: BorderRadius.circular(AppColors.radius),
        boxShadow: AppColors.shadowMd,
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isAdminUser ? AppColors.blue500 : AppColors.gray300,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.login,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  user.role.label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildIconButton(
            icon: Icons.edit_outlined,
            onTap: () => _goToUserEdit(user.id),
          ),
          const SizedBox(width: 6),
          _buildIconButton(
            icon: Icons.delete_outline,
            onTap: () => _openDeleteDialog(user.id, user.login),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppColors.radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppColors.radius),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.gray300),
            borderRadius: BorderRadius.circular(AppColors.radius),
          ),
          child: Icon(icon, size: 16, color: AppColors.gray600),
        ),
      ),
    );
  }
}
