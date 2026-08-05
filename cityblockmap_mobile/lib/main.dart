import 'package:cityblockmap_mobile/pages/blocks/block_list_page.dart';
import 'package:cityblockmap_mobile/pages/dashboard/dashboard_page.dart';
import 'package:cityblockmap_mobile/pages/login/login_page.dart';
import 'package:cityblockmap_mobile/pages/neighborhoods/neighborhood_list_page.dart';
import 'package:cityblockmap_mobile/pages/not-found/not_found_page.dart';
import 'package:cityblockmap_mobile/pages/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/blocks',
      builder: (context, state) => const BlockListPage(),
    ),
    GoRoute(
      path: '/neighborhoods',
      builder: (context, state) => const NeighborhoodListPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
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
    );
  }
}
