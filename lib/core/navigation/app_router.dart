import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../../features/auth/domain/entities/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

/// Navigation configuration for the app
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteConstants.splash,
    debugLogDiagnostics: false, // Disable debug logs to reduce noise
    routes: [
      // Splash route
      GoRoute(
        path: RouteConstants.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Authentication routes
      GoRoute(
        path: RouteConstants.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Home route
      GoRoute(
        path: RouteConstants.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // TODO: Add more routes as features are implemented
      // Store routes
      // GoRoute(
      //   path: RouteConstants.stores,
      //   name: 'stores',
      //   builder: (context, state) => const StoresPage(),
      // ),

      // // Product routes
      // GoRoute(
      //   path: RouteConstants.product,
      //   name: 'product',
      //   builder: (context, state) {
      //     final productId = state.pathParameters['productId']!;
      //     return ProductDetailPage(productId: productId);
      //   },
      // ),

      // // Cart route
      // GoRoute(
      //   path: RouteConstants.cart,
      //   name: 'cart',
      //   builder: (context, state) => const CartPage(),
      // ),

      // // Profile routes
      // GoRoute(
      //   path: RouteConstants.profile,
      //   name: 'profile',
      //   builder: (context, state) => const ProfilePage(),
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteConstants.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});