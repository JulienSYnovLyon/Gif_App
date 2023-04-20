// ignore_for_file: implementation_imports, use_key_in_widget_constructors, non_constant_identifier_names, annotate_overrides, must_call_super, prefer_const_constructors, body_might_complete_normally_nullable, sort_child_properties_last

import 'package:flutter/material.dart';
import 'AfficheCategorie.dart';
import 'SearchPage.dart';
import 'package:tenor/tenor.dart';
import 'package:tenor/src/utility/language_codes.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

List? categories;
List<String> NomCategories = <String>[];
List<String> ImageCategories = <String>[];

//clef créer sur le site de tenor
var apiKey = 'GPYW2QA0FNUZ';
//set de l'api
var api = Tenor(apiKey: apiKey, language: TenorLanguage.French);

class _HomePageState extends State<HomePage> {
  // permet de recuperer et de set sur la page toutes les catégories
  void initState() {
    getCategorie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catégories'),
        actions: [
          // Le click sur l'icon envoie sur la page de recherche
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SearchPage())),
              icon: Icon(Icons.search)),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) => Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
          ),
        ],
      ),
      //création d'une grille pour afficher toutes les catégories (gif + nom )
      body: GridView.builder(
        itemCount: NomCategories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (BuildContext context, int i) {
          // permet de faire en sorte que les images soit cliquables pour rediriger vers la catégories en question
          return InkWell(
              onTap: () {
                //envoie sur une page qui va chercher les gif de la catégories cliqués
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => AfficheCategorie(name: NomCategories[i])));
              },
              child: Container(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    NomCategories[i],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white),
                    minFontSize: 5,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(ImageCategories[i])))));
        },
      ),
    );
  }

  Future<List?> getCategorie() async {
    List<TenorCategories?> categories = await api.requestCategories();

    for (int i = 0; i < categories.length; i++) {
      // l'api renvoie une chaine de caractère contenant le nom , le lien ect
      String getProperties = categories[i].toString();
      //regex permettant de récupérer uniquement le nom
      final regeXPNom = RegExp(
          r'(?<=searchTerm:\s{1,10})[a-zA-Z0-9áàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ._-\s]+');
      final match = regeXPNom.firstMatch(getProperties);
      final matchedNom = match?.group(0);
      //regex permettant de récupérer le lien du gif
      final regeXPImage = RegExp(r'(?<=image:\s{1,10})[A-z:/.0-9]+');
      final match2 = regeXPImage.firstMatch(getProperties);
      final matchedImage = match2?.group(0);

      NomCategories.add(matchedNom.toString());
      ImageCategories.add(matchedImage.toString());
    }

    setState(() {
      // on set l'état des liste que la page puisse les utilisés
      categories = categories;
      NomCategories = NomCategories;
      ImageCategories = ImageCategories;
    });
  }
}
