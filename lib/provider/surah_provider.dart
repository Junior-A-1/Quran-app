import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_app/controller/surah_controller.dart';
import 'package:quran_app/models/surah.dart';

final surahListProvider = FutureProvider<List<Surah>>((ref) async {
  final surahController = SurahController();
  return await surahController.getSurahNames();
});
final currentSurahIndexProvider = StateProvider<int>((ref) => 0);
