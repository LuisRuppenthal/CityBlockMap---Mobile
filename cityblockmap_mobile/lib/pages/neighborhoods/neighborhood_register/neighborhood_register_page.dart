import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cityblockmap_mobile/core/models/neighborhood_model.dart';
import 'package:cityblockmap_mobile/core/services/neighborhood_service.dart';
import 'package:cityblockmap_mobile/core/theme/app_colors.dart';
import 'package:cityblockmap_mobile/widgets/common/app_alert.dart';
import 'package:cityblockmap_mobile/widgets/common/app_form_field.dart';

class NeighborhoodRegisterPage extends StatefulWidget {
  const NeighborhoodRegisterPage({super.key});

  @override
  State<NeighborhoodRegisterPage> createState() =>
      _NeighborhoodRegisterPageState();
}

class _NeighborhoodRegisterPageState extends State<NeighborhoodRegisterPage> {
  final _neighborhoodService = NeighborhoodService();
  final _nameController = TextEditingController();

  bool _loading = false;
  String? _errorMessage;
  String? _successMessage;

  void _goBack() {
    context.go('/neighborhoods');
  }

  Future<void> _register() async {
    if (_nameController.text.trim().isEmpty) {
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
      await _neighborhoodService.create(
        NeighborhoodRequest(name: _nameController.text.trim()),
      );

      if (!mounted) return;
      setState(() {
        _successMessage = 'Bairro cadastrado com sucesso!';
        _loading = false;
        _nameController.clear();
      });

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) context.go('/neighborhoods');
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = e.toString().contains('400')
            ? 'Dados inválidos. Verifique os campos.'
            : 'Erro ao cadastrar. Tente novamente.';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
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
                    'Novo Bairro',
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
                    'Preencha os dados para cadastrar um novo bairro',
                    style: TextStyle(fontSize: 14, color: AppColors.gray600),
                  ),
                  const SizedBox(height: 32),
                  if (_errorMessage != null)
                    AppAlert(message: _errorMessage!, type: AppAlertType.error),
                  if (_successMessage != null)
                    AppAlert(
                      message: _successMessage!,
                      type: AppAlertType.success,
                    ),
                  const AppFormLabel('Nome do Bairro'),
                  const SizedBox(height: 6),
                  AppFormTextField(
                    controller: _nameController,
                    hint: 'Ex: Parque X',
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
                          onPressed: _loading ? null : _register,
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
                            _loading ? 'Cadastrando...' : 'Cadastrar',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
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
