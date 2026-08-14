import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cityblockmap_mobile/core/models/neighborhood_model.dart';
import 'package:cityblockmap_mobile/core/services/auth_service.dart';
import 'package:cityblockmap_mobile/core/services/neighborhood_service.dart';
import 'package:cityblockmap_mobile/core/theme/app_colors.dart';
import 'package:cityblockmap_mobile/widgets/modals/delete_confirm_dialog.dart';

class NeighborhoodListPage extends StatefulWidget {
  const NeighborhoodListPage({super.key});

  @override
  State<NeighborhoodListPage> createState() => _NeighborhoodListPageState();
}

class _NeighborhoodListPageState extends State<NeighborhoodListPage> {
  final _neighborhoodService = NeighborhoodService();
  final _authService = AuthService();

  List<Neighborhood> _neighborhoods = [];
  bool _loading = false;
  String? _errorMessage;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadNeighborhoods();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final isAdmin = await _authService.isAdmin();
    if (mounted) setState(() => _isAdmin = isAdmin);
  }

  Future<void> _loadNeighborhoods() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final neighborhoods = await _neighborhoodService.getAll();
      if (mounted) setState(() => _neighborhoods = neighborhoods);
    } catch (_) {
      if (mounted)
        setState(() => _errorMessage = 'Erro ao carregar as quadras.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openNeighborhood(int id) {
    // teno que implementar aqui também
  }

  void _goToNeighborhoodEdit(int id) {
    context.push('/neighborhood-edit/$id');
  }

  Future<void> _openDeleteDialog(int id) async {
    final confirmed = await DeleteConfirmDialog.show(
      context,
      title: 'Excluir bairro',
      message:
          'Tem certeza que deseja excluir este bairro? Essa ação não pode ser desfeita.',
    );

    if (confirmed) {
      try {
        await _neighborhoodService.delete(id);
        await _loadNeighborhoods();
      } catch (_) {
        if (mounted) {
          setState(() => _errorMessage = 'Erro ao excluir o bairro.');
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
          onRefresh: _loadNeighborhoods,
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
              'Lista de Bairros',
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
        if (_isAdmin)
          ElevatedButton(
            onPressed: () => context.push('/neighborhood-register'),
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

    if (_neighborhoods.isEmpty) {
      return const Text(
        'Nenhuma quadra encontrada.',
        style: TextStyle(color: AppColors.gray600, fontSize: 14),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = (constraints.maxWidth / 260).floor().clamp(1, 6);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _neighborhoods.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 80,
          ),
          itemBuilder: (context, index) {
            return _buildNeighborhoodCard(_neighborhoods[index]);
          },
        );
      },
    );
  }

  Widget _buildNeighborhoodCard(Neighborhood neighborhood) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppColors.radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppColors.radius),
        onTap: () => _openNeighborhood(neighborhood.id),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
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
                decoration: const BoxDecoration(
                  color: AppColors.blue400,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  neighborhood.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_isAdmin) ...[
                const SizedBox(width: 8),
                _buildIconButton(
                  icon: Icons.edit_outlined,
                  color: AppColors.gray600,
                  hoverColor: AppColors.blue500,
                  onTap: () => _goToNeighborhoodEdit(neighborhood.id),
                ),
                const SizedBox(width: 6),
                _buildIconButton(
                  icon: Icons.delete_outline,
                  color: AppColors.gray600,
                  hoverColor: const Color(0xFFDC2626),
                  onTap: () => _openDeleteDialog(neighborhood.id),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required Color hoverColor,
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
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}
