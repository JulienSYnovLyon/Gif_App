// ignore_for_file: annotate_overrides, must_call_super, implementation_imports, no_logic_in_create_state, prefer_const_constructors, avoid_unnecessary_containers, body_might_complete_normally_nullable, avoid_print, avoid_function_literals_in_foreach_calls, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:tenor/tenor.dart';
import 'package:tenor/src/utility/language_codes.dart';

import 'DetailPage.dart';

//au click on envoie le nom de la catégorie il faut donc plusieurs étapes pour pouvoir l'utilisé
class AfficheCategorie extends StatefulWidget {
  final String name;
  const AfficheCategorie({Key? key, required this.name}) : super(key: key);

// on envoie a la class qui auras besoin d'utilisé la variable
  @override
  State<AfficheCategorie> createState() => _AfficheCategorie(name);
}

class _AfficheCategorie extends State<AfficheCategorie> {
  List<String> ResultList = <String>[];

  var apiKey = 'GPYW2QA0FNUZ';
  String nomCategorie = "";

  _AfficheCategorie(String name) {
    //récupération finale et utilisation désormais possible
    nomCategorie = name;
  }
  //on récupére l'api
  get api => Tenor(apiKey: apiKey, language: TenorLanguage.French);

  // on récupère et set les gif de la catégories cliqués sur la page précédente
  void initState() {
    getCategorie(nomCategorie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_interpolation_to_compose_strings
        title: Text("Catégories " + nomCategorie),
      ),
      body: GridView.builder(
        itemCount: ResultList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (BuildContext context, int i) {
          // permet que chaque gif soit cliquable
          return InkWell(
            onTap: () {
              // on envoie le gif en question a la page detail qui permet d'afficher le gif seul
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DetailPage(
                    LiensImages: ResultList[i],
                  ),
                ),
              );
            },
            child: Container(
              child: Image.network(
                ResultList[i],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List?> getCategorie(String nameCategorie) async {
    //Récupération des gif en fonction de la catégorie
    TenorResponse? res = await api.searchGIF(nameCategorie,
        limit: 50,
        contentFilter: ContentFilter.high,
        mediaFilter: MediaFilter.minimal);
    res?.results.forEach((TenorResult tenorResult) {
      var media = tenorResult.media;
      ResultList.add('${media?.gif?.url?.toString()}');
    });

    setState(() {
      //on set et on envoie a la page pour l'affichage
      ResultList = ResultList;
    });
  }
}
