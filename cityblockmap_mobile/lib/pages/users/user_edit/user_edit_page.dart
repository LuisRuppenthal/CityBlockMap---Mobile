import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cityblockmap_mobile/core/models/user_model.dart';
import 'package:cityblockmap_mobile/core/services/user_service.dart';
import 'package:cityblockmap_mobile/core/theme/app_colors.dart';
import 'package:cityblockmap_mobile/widgets/common/app_alert.dart';
import 'package:cityblockmap_mobile/widgets/common/app_form_field.dart';

class UserEditPage extends StatefulWidget {
  final int userId;

  const UserEditPage({super.key, required this.userId});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final _userService = UserService();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  UserRole? _selectedRole;
  bool _obscurePassword = true;

  bool _loadingUser = false;
  bool _loading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => _loadingUser = true);
    try {
      final user = await _userService.getById(widget.userId);
      if (mounted) {
        setState(() {
          _loginController.text = user.login;
          _selectedRole = user.role;
          _loadingUser = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro ao carregar o usuário.';
          _loadingUser = false;
        });
      }
    }
  }

  void _goBack() {
    context.go('/users');
  }

  Future<void> _update() async {
    final login = _loginController.text.trim();
    final password = _passwordController.text;

    // O backend exige senha não-vazia mesmo na edição (validação
    // @NotBlank no UserDTO), então sempre pedimos uma nova senha aqui.
    if (login.isEmpty || password.isEmpty || _selectedRole == null) {
      setState(() {
        _errorMessage = 'Preencha todos os campos obrigatórios.';
        _successMessage = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      await _userService.update(
        widget.userId,
        UserRequest(login: login, password: password, role: _selectedRole!),
      );

      if (!mounted) return;
      setState(() {
        _successMessage = 'Usuário atualizado com sucesso!';
        _loading = false;
      });

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) context.go('/users');
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = e.toString().contains('400')
            ? 'Dados inválidos. Verifique os campos.'
            : 'Erro ao salvar. Tente novamente.';
      });
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              padding: const EdgeInsets.fromLTRB(48, 40, 48, 40),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.gray300),
                borderRadius: BorderRadius.circular(AppColors.radius),
                boxShadow: AppColors.shadowLg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Editar Usuário',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(height: 4, width: 36, color: AppColors.blue500),
                  const SizedBox(height: 14),
                  const Text(
                    'Altere os dados do usuário e salve as alterações',
                    style: TextStyle(fontSize: 14, color: AppColors.gray600),
                  ),
                  const SizedBox(height: 32),
                  if (_loadingUser)
                    const Text(
                      'Carregando dados do usuário...',
                      style: TextStyle(fontSize: 14, color: AppColors.gray600),
                    )
                  else ...[
                    if (_errorMessage != null)
                      AppAlert(
                        message: _errorMessage!,
                        type: AppAlertType.error,
                      ),
                    if (_successMessage != null)
                      AppAlert(
                        message: _successMessage!,
                        type: AppAlertType.success,
                      ),

                    const AppFormLabel('Login'),
                    const SizedBox(height: 6),
                    AppFormTextField(
                      controller: _loginController,
                      hint: 'Digite o login',
                    ),
                    const SizedBox(height: 18),

                    AppFormLabel(
                      'Nova senha',
                      hint: '(obrigatório para salvar)',
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.gray900,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Digite a nova senha',
                        hintStyle: const TextStyle(color: AppColors.gray300),
                        filled: true,
                        fillColor: AppColors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.gray600,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.gray300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.blue400,
                            width: 1.5,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.gray300,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    const AppFormLabel('Perfil'),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<UserRole>(
                      initialValue: _selectedRole,
                      items: UserRole.values
                          .map(
                            (role) => DropdownMenuItem(
                              value: role,
                              child: Text(role.label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => _selectedRole = value);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.gray300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.blue400,
                            width: 1.5,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.gray300,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _goBack,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              foregroundColor: AppColors.gray600,
                              side: const BorderSide(color: AppColors.gray300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _loading ? null : _update,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              backgroundColor: AppColors.blue500,
                              foregroundColor: AppColors.white,
                              disabledBackgroundColor: AppColors.blue500
                                  .withValues(alpha: 0.6),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              _loading ? 'Salvando...' : 'Salvar',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
