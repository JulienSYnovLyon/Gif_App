// ignore_for_file: implementation_imports, avoid_print, non_constant_identifier_names, prefer_const_constructors, avoid_unnecessary_containers, avoid_function_literals_in_foreach_calls, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:tenor/tenor.dart';
import 'package:tenor/src/utility/language_codes.dart';

import 'DetailPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> ResultList = <String>[];
  var apiKey = 'GPYW2QA0FNUZ';
  get api => Tenor(apiKey: apiKey, language: TenorLanguage.French);

  TextEditingController searchText = TextEditingController();

  void clearText() {
    searchText.clear();
  }

  //on clear a chaque changement pour toujours avoir les gif en relation avec la dernière lettre tappée
  void clearSearch() {
    ResultList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: TextField(
            controller: searchText,
            onChanged: (enteredValue) {
              clearSearch();
              SearchGif(enteredValue);
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  clearText();
                  SearchGif("");
                },
              ),
              hintText: 'Recherche...',
              border: InputBorder.none,
            ),
          ),
        ),
      )),
      body: ResultList.isEmpty /* Ajout pour les aucuns résultats */
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://cdn-icons-png.flaticon.com/512/1357/1357605.png',
                    width: 150,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text("Aucun résultat"),
                ],
              ),
            )
          : GridView.builder(
              itemCount: ResultList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (BuildContext context, int i) {
                return InkWell(
                  onTap: () {
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

  Future<List?> SearchGif(String enteredValue) async {
    // pour ne pas surcharger les call api on attends un minimum de 3 caractère avant de lancer la recherche
    if (enteredValue.length >= 3) {
      TenorResponse? res = await api.searchGIF(enteredValue,
          limit: 50,
          contentFilter: ContentFilter.high,
          mediaFilter: MediaFilter.minimal);
      res?.results.forEach((TenorResult tenorResult) {
        var media = tenorResult.media;
        ResultList.add('${media?.gif?.url?.toString()}');
      });
    } else {
      ResultList = [];
    }

    setState(() {
      //on set et on envoie a la page pour l'affichage
      ResultList = ResultList;
    });
  }
}
