import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:vet_reports_app/core/constants/strings.dart';
/*import 'package:vet_reports_app/core/utils/animations.dart';*/
import 'package:vet_reports_app/features//reports/cubit/reports_cubit.dart';

class DatabaseSelectorScreen extends StatelessWidget {
  const DatabaseSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.selectDatabase),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/database.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 30),
            Text(
              AppStrings.selectDatabasePrompt,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ..._buildDatabaseOptions(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDatabaseOptions(BuildContext context) {
    final options = [
      AppStrings.elanamKhamisMushit,
      AppStrings.elanamBaish,
      AppStrings.elanamZapia,
    ];

    return options.map((option) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            context.read<ReportsCubit>().selectDatabase(option);
            Navigator.pushNamed(context, '/date_range');
          },
          child: Text(
            option,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      );
    }).toList();
  }
}