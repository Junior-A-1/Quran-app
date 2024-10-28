import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_app/controller/quran_controller.dart';
import 'package:quran_app/views/widgets/navigation_button.dart';
import 'widgets/surah_dropdown.dart';
import 'widgets/ayah_list.dart';

class MainScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quranState = ref.watch(quranProvider);
    final controller = ref.read(quranProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran Reader'),
      ),
      body: quranState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SurahDropdown(
                    surahs: quranState.surahs,
                    selectedSurah: quranState.currentSurah,
                    onSurahChanged: (newSurah) {
                      controller.selectSurah(newSurah);
                    },
                  ),
                  Expanded(
                    child: AyahList(ayahs: controller.paginatedAyahs),
                  ),
                  NavigationButtons(
                    onNextPressed: controller.goToNextPage,
                    onPreviousPressed: () {
                      if (quranState.currentAyahPage > 0) {
                        controller.goToNextPage();
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
