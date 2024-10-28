// widgets/surah_dropdown.dart
import 'package:flutter/material.dart';
import 'package:quran_app/models/surah.dart';

class SurahDropdown extends StatelessWidget {
  final List<Surah> surahs;
  final int selectedSurah;
  final Function(int) onSurahChanged;

  SurahDropdown({
    required this.surahs,
    required this.selectedSurah,
    required this.onSurahChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: selectedSurah,
      onChanged: (int? newValue) {
        if (newValue != null) {
          onSurahChanged(newValue);
        }
      },
      items: surahs.map((surah) {
        return DropdownMenuItem<int>(
          value: surah.number,
          child: Text(surah.englishName),
        );
      }).toList(),
    );
  }
}
