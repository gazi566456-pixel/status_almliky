import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 👇 استبدلها بشاشتك الرئيسية الحقيقية
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Status Getter')),
      body: const Center(
        child: Text('App Started 🚀'),
      ),
    );
  }
}

class RouterNavigator {
  late final GoRouter router;

  RouterNavigator() {
    router = GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,

      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
      ],

      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Error: ${state.error}'),
        ),
      ),
    );
  }
}
