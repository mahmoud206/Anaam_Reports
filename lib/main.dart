import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vet_reports_app/app/app_routes.dart';
import 'package:vet_reports_app/features/reports/cubit/reports_cubit.dart';
import 'package:vet_reports_app/core/services/mongo_service.dart';
import 'package:vet_reports_app/core/services/pdf_service.dart';


void main() {
  // Initialize services first
  final mongoService = MongoService();
  final pdfService = PdfService();

  runApp(VetReportsApp(
    mongoService: mongoService,
    pdfService: pdfService,
  ));
}

class VetReportsApp extends StatelessWidget {
  final MongoService _mongoService;
  final PdfService _pdfService;

  const VetReportsApp({
    super.key,
    required MongoService mongoService,
    required PdfService pdfService,
  }) : _mongoService = mongoService,
        _pdfService = pdfService;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportsCubit(_mongoService, _pdfService),
      child: MaterialApp(
        title: 'Vet Reports',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Tajawal',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        locale: const Locale('ar'),
        onGenerateRoute: AppRoutes.onGenerateRoute,
        initialRoute: AppRoutes.intro,
      ),
    );
  }
}