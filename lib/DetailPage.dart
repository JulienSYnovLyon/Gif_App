// ignore_for_file: must_be_immutable, unnecessary_string_interpolations, deprecated_member_use, non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class DetailPage extends StatelessWidget {
  String? LiensImages;
  DetailPage({Key? key, this.LiensImages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(children: <Widget>[
        Image.network(LiensImages!),
        ElevatedButton(
          onPressed: () => {share(LiensImages!)},
          child: Text('Partager'),
        ),
      ])),
    );
  }

  //permet de partager le lien du gif avec un message sur les app disponibles sur le téléphone
  Future<void> share(String link) async {
    await FlutterShare.share(
        title: 'Envoie de gif',
        text: 'Tiens je te partage ce gif ! ',
        linkUrl: link,
        chooserTitle: 'Envoie de gif');
  }
}
