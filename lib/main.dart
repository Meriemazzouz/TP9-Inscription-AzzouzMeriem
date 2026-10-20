import 'package:flutter/material.dart';

import 'screens/step_one_screen.dart';

void main() => runApp(const InscriptionApp());

class InscriptionApp extends StatelessWidget {
  const InscriptionApp({super.key});

  // Valeurs reprises des styles Figma
  static const Color primary = Color(0xFF00A8CC);
  static const Color error = Color(0xFFD32F2F);
  static const Color fieldBackground = Color(0xFFF2F7F9);

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: primary, error: error);
    final rayon = BorderRadius.circular(8);

    return MaterialApp(
      title: 'TP8 Inscription',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        appBarTheme: AppBarTheme(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: fieldBackground,
          border: OutlineInputBorder(borderRadius: rayon),
          enabledBorder: OutlineInputBorder(
            borderRadius: rayon,
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: rayon,
            borderSide: const BorderSide(color: primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: rayon,
            borderSide: const BorderSide(color: error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: rayon,
            borderSide: const BorderSide(color: error, width: 2),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: const StadiumBorder(),
          ),
        ),
      ),
      home: const StepOneScreen(),
    );
  }
}
