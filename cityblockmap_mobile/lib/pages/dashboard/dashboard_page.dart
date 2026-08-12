import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cityblockmap_mobile/enviroment.dart';
import 'package:cityblockmap_mobile/core/interceptors/auth_interceptor.dart';
import 'package:cityblockmap_mobile/core/services/auth_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _authService = AuthService();

  int _blockCount = 0;
  int _neighborhoodCount = 0;
  bool _loadingBlocks = false;
  bool _loadingNeighborhoods = false;
  bool _isAdmin = false;

  static const _blue900 = Color(0xFF0F1F3D);
  static const _blue500 = Color(0xFF2563EB);
  static const _blue50 = Color(0xFFEFF6FF);
  static const _gray600 = Color(0xFF4B5563);
  static const _gray300 = Color(0xFFD1D5DB);

  @override
  void initState() {
    super.initState();
    _loadCounts();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final isAdmin = await _authService.isAdmin();
    if (mounted) setState(() => _isAdmin = isAdmin);
  }

  Future<void> _loadCounts() async {
    setState(() {
      _loadingBlocks = true;
      _loadingNeighborhoods = true;
    });

    try {
      final response = await authInterceptor.get(
        Uri.parse('${Environment.apiUrl}/blocks'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        if (mounted) setState(() => _blockCount = data.length);
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loadingBlocks = false);
    }

    try {
      final response = await authInterceptor.get(
        Uri.parse('${Environment.apiUrl}/neighborhoods/get'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        if (mounted) setState(() => _neighborhoodCount = data.length);
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loadingNeighborhoods = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _blue900,
                ),
              ),
              const SizedBox(height: 8),
              Container(height: 4, width: 48, color: _blue500),
              const SizedBox(height: 14),
              const Text(
                'Selecione uma seção para continuar',
                style: TextStyle(fontSize: 14, color: _gray600),
              ),
              const SizedBox(height: 32),
              _buildCard(
                title: 'Quadras',
                loading: _loadingBlocks,
                count: _blockCount,
                suffix: 'cadastradas',
                icon: Icons.map_outlined,
                onTap: () => context.push('/blocks'),
              ),
              const SizedBox(height: 16),
              _buildCard(
                title: 'Bairros',
                loading: _loadingNeighborhoods,
                count: _neighborhoodCount,
                suffix: 'cadastrados',
                icon: Icons.location_city_outlined,
                onTap: () => context.push('/neighborhoods'),
              ),
              // Card de usuários, só para ADMIN — equivalente ao bloco
              // comentado no dashboard.html original
              if (_isAdmin) ...[
                const SizedBox(height: 16),
                _buildCard(
                  title: 'Usuários',
                  loading: false,
                  count: null,
                  suffix: 'Gerenciar usuários',
                  icon: Icons.people_outline,
                  onTap: () => context.push('/register'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required bool loading,
    required int? count,
    required String suffix,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _gray300),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _blue50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: _blue500, size: 26),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _blue900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loading
                        ? 'Carregando...'
                        : count != null
                        ? '$count $suffix'
                        : suffix,
                    style: const TextStyle(fontSize: 13, color: _gray600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, size: 18, color: _gray300),
          ],
        ),
      ),
    );
  }
}
