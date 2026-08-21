import 'package:cityblockmap_mobile/core/guards/admin_guard.dart';
import 'package:cityblockmap_mobile/core/guards/auth_guard.dart';
import 'package:cityblockmap_mobile/core/navigation/navigator_key.dart';
import 'package:cityblockmap_mobile/pages/blocks/block_edit/block_edit_page.dart';
import 'package:cityblockmap_mobile/pages/blocks/block_list/block_list_page.dart';
import 'package:cityblockmap_mobile/pages/blocks/block_map/block_map_page.dart';
import 'package:cityblockmap_mobile/pages/blocks/block_register/block_register_page.dart';
import 'package:cityblockmap_mobile/pages/dashboard/dashboard_page.dart';
import 'package:cityblockmap_mobile/pages/login/login_page.dart';
import 'package:cityblockmap_mobile/pages/neighborhoods/neighborhood_edit/neighborhood_edit_page.dart';
import 'package:cityblockmap_mobile/pages/neighborhoods/neighborhood_list/neighborhood_list_page.dart';
import 'package:cityblockmap_mobile/pages/neighborhoods/neighborhood_register/neighborhood_register_page.dart';
import 'package:cityblockmap_mobile/pages/not-found/not_found_page.dart';
import 'package:cityblockmap_mobile/pages/register/register_page.dart';
import 'package:cityblockmap_mobile/pages/users/user_edit/user_edit_page.dart';
import 'package:cityblockmap_mobile/pages/users/user_list/user_list_page.dart';
import 'package:cityblockmap_mobile/widgets/common/app_header.dart';
import 'package:cityblockmap_mobile/widgets/common/session_expired_banner.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/login',
  redirect: (context, state) async {
    final location = state.matchedLocation;

    final authRedirect = await AuthGuard.redirect(location);
    if (authRedirect != null) return authRedirect;

    final adminRedirect = await AdminGuard.redirect(location);
    if (adminRedirect != null) return adminRedirect;

    return null;
  },
  routes: [
    // Aqui o Login vai ficar FORA do ShellRoute, dessa forma ele não vai mostrar o header na pagina de Login
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

    // Todas as demais rotas vão ficar dentro do ShellRoute, que injeta o AppHeader na parte de cima de cada página
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: Column(
            children: [
              const AppHeader(),
              Expanded(child: child),
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/blocks',
          builder: (context, state) => const BlockListPage(),
        ),
        GoRoute(
          path: '/blocks/:id',
          builder: (context, state) =>
              BlockMapPage(blockId: int.parse(state.pathParameters['id']!)),
        ),
        GoRoute(
          path: '/block-register',
          builder: (context, state) => const BlockRegisterPage(),
        ),
        GoRoute(
          path: '/block-edit/:id',
          builder: (context, state) =>
              BlockEditPage(blockId: int.parse(state.pathParameters['id']!)),
        ),
        GoRoute(
          path: '/neighborhoods',
          builder: (context, state) => const NeighborhoodListPage(),
        ),
        GoRoute(
          path: '/neighborhood-register',
          builder: (context, state) => const NeighborhoodRegisterPage(),
        ),
        GoRoute(
          path: '/neighborhood-edit/:id',
          builder: (context, state) => NeighborhoodEditPage(
            neighborhoodId: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/users',
          builder: (context, state) => const UserListPage(),
        ),
        GoRoute(
          path: '/user-edit/:id',
          builder: (context, state) =>
              UserEditPage(userId: int.parse(state.pathParameters['id']!)),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const NotFoundPage(),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CityBlockMap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      routerConfig: _router,
      builder: (context, child) {
        return Stack(
          children: [if (child != null) child, const SessionExpiredBanner()],
        );
      },
    );
  }
}
