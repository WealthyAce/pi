// import route
import 'package:testingpi/views/nutrition_detail_view.dart';
import 'package:testingpi/views/personalization_hub_view.dart';
import 'package:testingpi/views/homemade_food_view.dart';
import 'package:testingpi/views/smarter_alternatives_view.dart';
import 'package:testingpi/views/nutrition_chatbot.dart';
import 'package:testingpi/views/scan/scanner_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriScan AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PersonalizationHubView(),
        '/nutrition-detail': (context) => const NutritionDetailView(),
        '/homemade-food': (context) => const HomemadeFoodView(),
        '/smarter-alternatives': (context) => const SmarterAlternativesView(),
        '/nutrition-chatbot': (context) => const NutritionChatView(),
        '/scan': (context) => const ScannerView(),
      },
    );
  }
}
