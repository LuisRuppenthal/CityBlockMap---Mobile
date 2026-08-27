import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:cityblockmap_mobile/core/models/block_model.dart';
import 'package:cityblockmap_mobile/core/models/neighborhood_model.dart';
import 'package:cityblockmap_mobile/core/services/block_service.dart';
import 'package:cityblockmap_mobile/core/services/neighborhood_service.dart';
import 'package:cityblockmap_mobile/core/theme/app_colors.dart';
import 'package:cityblockmap_mobile/core/theme/responsive.dart';
import 'package:cityblockmap_mobile/widgets/common/app_alert.dart';
import 'package:cityblockmap_mobile/widgets/common/app_form_field.dart';
import 'package:cityblockmap_mobile/widgets/modals/map_picker_modal.dart';

class BlockRegisterPage extends StatefulWidget {
  const BlockRegisterPage({super.key});

  @override
  State<BlockRegisterPage> createState() => _BlockRegisterPageState();
}

class _BlockRegisterPageState extends State<BlockRegisterPage> {
  final _blockService = BlockService();
  final _neighborhoodService = NeighborhoodService();

  final _numberController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  List<Neighborhood> _neighborhoods = [];
  int? _selectedNeighborhoodId;
  bool _loadingNeighborhoods = false;

  bool _loading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _loadNeighborhoods();
  }

  Future<void> _loadNeighborhoods() async {
    setState(() => _loadingNeighborhoods = true);
    try {
      final neighborhoods = await _neighborhoodService.getAll();
      if (mounted) {
        setState(() => _neighborhoods = neighborhoods);
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() => _loadingNeighborhoods = false);
      }
    }
  }

  void _goBack() {
    context.go('/blocks');
  }

  Future<void> _openMapPicker() async {
    LatLng? initialPoint;
    final lat = double.tryParse(_latitudeController.text.replaceAll(',', '.'));
    final lng = double.tryParse(_longitudeController.text.replaceAll(',', '.'));
    if (lat != null && lng != null) {
      initialPoint = LatLng(lat, lng);
    }

    final result = await MapPickerModal.show(
      context,
      initialPoint: initialPoint,
    );
    if (result != null) {
      setState(() {
        _latitudeController.text = result.latitude.toStringAsFixed(6);
        _longitudeController.text = result.longitude.toStringAsFixed(6);
      });
    }
  }

  Future<void> _register() async {
    final number = _numberController.text.trim();
    final latText = _latitudeController.text.trim();
    final lngText = _longitudeController.text.trim();

    if (number.isEmpty ||
        latText.isEmpty ||
        lngText.isEmpty ||
        _selectedNeighborhoodId == null) {
      setState(() {
        _errorMessage = 'Preencha todos os campos obrigatórios.';
        _successMessage = null;
      });
      return;
    }

    final lat = double.tryParse(latText.replaceAll(',', '.'));
    if (lat == null || lat < -90 || lat > 90) {
      setState(
        () => _errorMessage = 'Latitude inválida. Use valores entre -90 e 90.',
      );
      return;
    }

    final lng = double.tryParse(lngText.replaceAll(',', '.'));
    if (lng == null || lng < -180 || lng > 180) {
      setState(
        () =>
            _errorMessage = 'Longitude inválida. Use valores entre -180 e 180.',
      );
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      await _blockService.create(
        BlockRequest(
          number: number,
          latitude: lat,
          longitude: lng,
          neighborhoodId: _selectedNeighborhoodId!,
        ),
      );

      if (!mounted) return;
      setState(() {
        _successMessage = 'Quadra cadastrada com sucesso!';
        _loading = false;
        _numberController.clear();
        _latitudeController.clear();
        _longitudeController.clear();
        _selectedNeighborhoodId = null;
      });

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) context.go('/blocks');
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
    _numberController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
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
                    'Nova Quadra',
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
                    'Preencha os dados para cadastrar uma nova quadra',
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

                  const AppFormLabel('Número / Nome'),
                  const SizedBox(height: 6),
                  AppFormTextField(
                    controller: _numberController,
                    hint: 'Ex: Quadra 05',
                  ),
                  const SizedBox(height: 18),

                  AppFormLabel('Latitude', hint: '(-90 a 90)'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _latitudeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.gray900,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ex: -12.1234',
                      hintStyle: const TextStyle(color: AppColors.gray300),
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.map_outlined,
                          color: AppColors.blue500,
                        ),
                        tooltip: 'Selecionar no mapa',
                        onPressed: _openMapPicker,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.gray300),
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
                        borderSide: const BorderSide(color: AppColors.gray300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  AppFormLabel('Longitude', hint: '(-180 a 180)'),
                  const SizedBox(height: 6),
                  AppFormTextField(
                    controller: _longitudeController,
                    hint: 'Ex: -12.1234',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                  ),
                  const SizedBox(height: 18),

                  const AppFormLabel('Bairro'),
                  const SizedBox(height: 6),
                  _loadingNeighborhoods
                      ? const Text(
                          'Carregando bairros...',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.gray600,
                          ),
                        )
                      : DropdownButtonFormField<int>(
                          initialValue: _selectedNeighborhoodId,
                          hint: const Text(
                            'Selecione um bairro',
                            style: TextStyle(
                              color: AppColors.gray300,
                              fontSize: 15,
                            ),
                          ),
                          items: _neighborhoods
                              .map(
                                (n) => DropdownMenuItem(
                                  value: n.id,
                                  child: Text(n.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() => _selectedNeighborhoodId = value);
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
