import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:statusgetter/views/dashboard/dashboard_view.dart';

class RouterNavigator {
  late final GoRouter router;

  RouterNavigator() {
    router = GoRouter(
      initialLocation: '/', // 🔥 مهم جدًا

      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardView(), // 👈 هذا هو الحل
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
