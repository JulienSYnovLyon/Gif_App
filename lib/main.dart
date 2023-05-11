// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'HomePage.dart';
import 'theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) =>
          ThemeProvider(), // Crée une instance de ThemeProvider et la fournit aux widgets enfants
      child: MyApp(), // Exécute l'application MyApp
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Search Gif',
      theme: Provider.of<ThemeProvider>(context)
          .getTheme(), // Obtient le thème actuel à partir du fournisseur de thème
      home:
          HomePage(), // Définit la page d'accueil de l'application comme étant HomePage()
    );
  }
}
