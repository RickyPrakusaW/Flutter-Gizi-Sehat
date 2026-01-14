/// Wrapper screen untuk handle auth redirects dengan Riverpod
/// Wrapper untuk route protection dan auth-based redirects
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class AuthWrapper extends ConsumerWidget {
  final Widget child;

  const AuthWrapper({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state untuk trigger redirect jika diperlukan
    final authState = ref.watch(authStateStreamProvider);

    return authState.when(
      data: (user) {
        // User authenticated, render child
        return child;
      },
      loading: () {
        // Loading state
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Memuat...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        // Error state - redirect to login
        Future.microtask(() => context.go('/login'));
        return const SizedBox.shrink();
      },
    );
  }
}
