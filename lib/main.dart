import 'package:favorite_places/screens/places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 102, 6, 247),
  surface: const Color.fromARGB(255, 56, 49, 66),
);

final baseTheme = ThemeData.from(colorScheme: colorScheme, useMaterial3: true);

final theme = baseTheme.copyWith(
  scaffoldBackgroundColor: colorScheme.surface,
  appBarTheme: AppBarTheme(
    backgroundColor: colorScheme.primaryContainer, // or any color you like
    foregroundColor: colorScheme.onPrimaryContainer,
    surfaceTintColor: Colors.transparent, // stops the color shifting on scroll
  ),
  textTheme: GoogleFonts.ubuntuCondensedTextTheme(baseTheme.textTheme).copyWith(
    titleSmall: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
    titleMedium: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
    titleLarge: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
  ),
);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Great Places',
      theme: theme,
      home: const Scaffold(body: Center(child: PlacesScreen())),
    );
  }
}
