import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:labtest1/app_routes.dart';
import 'package:labtest1/utils/theme/app_theme.dart';
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ভূমি উন্নয়ন কর',
      theme: AppTheme.theme,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generateRoute,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
      showPerformanceOverlay: false,
    );
  }
}
