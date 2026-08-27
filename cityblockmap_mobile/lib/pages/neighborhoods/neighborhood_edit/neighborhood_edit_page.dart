import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cityblockmap_mobile/core/models/neighborhood_model.dart';
import 'package:cityblockmap_mobile/core/services/neighborhood_service.dart';
import 'package:cityblockmap_mobile/core/theme/app_colors.dart';
import 'package:cityblockmap_mobile/core/theme/responsive.dart';
import 'package:cityblockmap_mobile/widgets/common/app_alert.dart';
import 'package:cityblockmap_mobile/widgets/common/app_form_field.dart';

class NeighborhoodEditPage extends StatefulWidget {
  final int neighborhoodId;

  const NeighborhoodEditPage({super.key, required this.neighborhoodId});

  @override
  State<NeighborhoodEditPage> createState() => _NeighborhoodEditPageState();
}

class _NeighborhoodEditPageState extends State<NeighborhoodEditPage> {
  final _neighborhoodService = NeighborhoodService();
  final _nameController = TextEditingController();

  bool _loadingNeighborhood = false;
  bool _loading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _loadNeighborhood();
  }

  Future<void> _loadNeighborhood() async {
    setState(() => _loadingNeighborhood = true);

    try {
      final neighborhood = await _neighborhoodService.getById(
        widget.neighborhoodId,
      );
      if (!mounted) return;
      setState(() {
        _nameController.text = neighborhood.name;
        _loadingNeighborhood = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erro ao carregar o bairro.';
        _loadingNeighborhood = false;
      });
    }
  }

  void _goBack() {
    context.go('/neighborhoods');
  }

  Future<void> _update() async {
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
      await _neighborhoodService.update(
        widget.neighborhoodId,
        NeighborhoodRequest(name: _nameController.text.trim()),
      );

      if (!mounted) return;
      setState(() {
        _successMessage = 'Bairro atualizado com sucesso!';
        _loading = false;
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
            : 'Erro ao salvar. Tente novamente.';
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
          padding: EdgeInsets.all(context.isMobile ? 12 : 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              padding: EdgeInsets.fromLTRB(
                context.isMobile ? 20 : 48,
                context.isMobile ? 28 : 40,
                context.isMobile ? 20 : 48,
                context.isMobile ? 28 : 40,
              ),
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
                    'Editar Bairro',
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
                    'Altere os dados do bairro e salve as alterações',
                    style: TextStyle(fontSize: 14, color: AppColors.gray600),
                  ),
                  const SizedBox(height: 32),
                  if (_loadingNeighborhood)
                    const Text(
                      'Carregando dados do bairro...',
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
