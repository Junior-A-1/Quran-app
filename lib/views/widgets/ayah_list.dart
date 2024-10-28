import 'package:flutter/material.dart';
import 'package:quran_app/models/ayah.dart';

class AyahList extends StatelessWidget {
  final List<Ayah> ayahs;

  AyahList({required this.ayahs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ayahs.length,
      itemBuilder: (context, index) {
        final ayah = ayahs[index];
        return ListTile(
          title: Text(ayah.text),
        );
      },
    );
  }
}
