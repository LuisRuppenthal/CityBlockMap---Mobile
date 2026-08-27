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

class BlockEditPage extends StatefulWidget {
  final int blockId;

  const BlockEditPage({super.key, required this.blockId});

  @override
  State<BlockEditPage> createState() => _BlockEditPageState();
}

class _BlockEditPageState extends State<BlockEditPage> {
  final _blockService = BlockService();
  final _neighborhoodService = NeighborhoodService();

  final _numberController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  List<Neighborhood> _neighborhoods = [];
  int? _selectedNeighborhoodId;

  bool _loadingBlock = false;
  bool _loadingNeighborhoods = false;
  bool _loading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loadingBlock = true;
      _loadingNeighborhoods = true;
    });

    try {
      final neighborhoods = await _neighborhoodService.getAll();
      if (mounted) {
        setState(() {
          _neighborhoods = neighborhoods;
          _loadingNeighborhoods = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loadingNeighborhoods = false);
      }
    }

    try {
      final block = await _blockService.getById(widget.blockId);
      if (mounted) {
        setState(() {
          _numberController.text = block.number;
          _latitudeController.text = block.latitude.toString();
          _longitudeController.text = block.longitude.toString();
          _selectedNeighborhoodId = block.neighborhood?.id;
          _loadingBlock = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro ao carregar a quadra.';
          _loadingBlock = false;
        });
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

  Future<void> _update() async {
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
      await _blockService.update(
        widget.blockId,
        BlockRequest(
          number: number,
          latitude: lat,
          longitude: lng,
          neighborhoodId: _selectedNeighborhoodId!,
        ),
      );

      if (!mounted) return;
      setState(() {
        _successMessage = 'Quadra atualizada com sucesso!';
        _loading = false;
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
            : 'Erro ao salvar. Tente novamente.';
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
                    'Editar Quadra',
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
                    'Altere os dados da quadra e salve as alterações',
                    style: TextStyle(fontSize: 14, color: AppColors.gray600),
                  ),
                  const SizedBox(height: 32),
                  if (_loadingBlock)
                    const Text(
                      'Carregando dados da quadra...',
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
