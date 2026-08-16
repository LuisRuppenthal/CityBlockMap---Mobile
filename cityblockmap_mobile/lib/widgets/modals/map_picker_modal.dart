import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cityblockmap_mobile/core/theme/app_colors.dart';

class MapPickerModal extends StatefulWidget {
  final LatLng? initialPoint;

  const MapPickerModal({super.key, this.initialPoint});

  static Future<LatLng?> show(BuildContext context, {LatLng? initialPoint}) {
    return showDialog<LatLng>(
      context: context,
      barrierDismissible: false,
      builder: (context) => MapPickerModal(initialPoint: initialPoint),
    );
  }

  @override
  State<MapPickerModal> createState() => _MapPickerModalState();
}

class _MapPickerModalState extends State<MapPickerModal> {
  static const _defaultCenter = LatLng(-15.7801, -47.9292);

  LatLng? _selectedPoint;

  @override
  void initState() {
    super.initState();
    _selectedPoint = widget.initialPoint;
  }

  void _onTap(TapPosition tapPosition, LatLng point) {
    setState(() => _selectedPoint = point);
  }

  void _confirm() {
    Navigator.of(context).pop(_selectedPoint);
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radius),
      ),
      child: SizedBox(
        width: 600,
        height: 600,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Selecione a localização',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue900,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.gray600),
                    onPressed: _cancel,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: _selectedPoint ?? _defaultCenter,
                      initialZoom: _selectedPoint != null ? 14 : 4,
                      onTap: _onTap,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.cityblockmap.mobile',
                      ),
                      if (_selectedPoint != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _selectedPoint!,
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.location_pin,
                                color: AppColors.accent,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: AppColors.shadowMd,
                      ),
                      child: Text(
                        _selectedPoint != null
                            ? 'Lat: ${_selectedPoint!.latitude.toStringAsFixed(4)}  '
                                  'Lng: ${_selectedPoint!.longitude.toStringAsFixed(4)}'
                            : 'Toque no mapa para marcar o ponto',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.gray600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        foregroundColor: AppColors.gray600,
                        side: const BorderSide(color: AppColors.gray300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedPoint != null ? _confirm : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        backgroundColor: AppColors.blue500,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Confirmar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
