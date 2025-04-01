import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
/*import 'package:flutter_bloc/flutter_bloc.dart';*/
import 'package:flutter_animate/flutter_animate.dart';

import '../core/constants/strings.dart';
import 'package:vet_reports_app/app/app_theme.dart';
import 'package:vet_reports_app/app/app_routes.dart';
import 'package:vet_reports_app/features/intro/intro_page.dart';

class VetReportsApp extends StatelessWidget {
  const VetReportsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'),
      ],
      locale: const Locale('ar', 'SA'),
      home: const IntroPage(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    ).animate().fadeIn(duration: 500.ms);
  }
}