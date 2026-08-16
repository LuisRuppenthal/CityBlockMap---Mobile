import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cityblockmap_mobile/core/models/block_model.dart';
import 'package:cityblockmap_mobile/core/services/block_service.dart';
import 'package:cityblockmap_mobile/core/theme/app_colors.dart';

class BlockMapPage extends StatefulWidget {
  final int blockId;

  const BlockMapPage({super.key, required this.blockId});

  @override
  State<BlockMapPage> createState() => _BlockMapPageState();
}

class _BlockMapPageState extends State<BlockMapPage> {
  final _blockService = BlockService();

  Block? _block;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBlock();
  }

  Future<void> _loadBlock() async {
    try {
      final block = await _blockService.getById(widget.blockId);
      if (mounted) {
        setState(() => _block = block);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Erro ao carregar a quadra.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_errorMessage != null) _buildErrorMessage(),
              if (_block != null) ...[
                _buildInfoCard(_block!),
                const SizedBox(height: 24),
              ],
              _buildMapCard(_block),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        border: Border.all(color: const Color(0xFFFECACA)),
        borderRadius: BorderRadius.circular(AppColors.radius),
      ),
      child: Text(
        _errorMessage!,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFFDC2626),
        ),
      ),
    );
  }

  Widget _buildInfoCard(Block block) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.gray300),
        borderRadius: BorderRadius.circular(AppColors.radius),
        boxShadow: AppColors.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            block.number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.blue900,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _buildInfoItem('Bairro', block.neighborhood?.name ?? '—'),
              _buildInfoItem('Latitude', block.latitude.toString()),
              _buildInfoItem('Longitude', block.longitude.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: AppColors.blue500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.gray900,
          ),
        ),
      ],
    );
  }

  Widget _buildMapCard(Block? block) {
    return Container(
      height: 500,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppColors.radius),
        border: Border.all(color: AppColors.gray300),
        boxShadow: AppColors.shadowLg,
      ),
      child: block == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.blue500),
            )
          : FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(block.latitude, block.longitude),
                initialZoom: 16,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.cityblockmap.mobile',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(block.latitude, block.longitude),
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
    );
  }
}
