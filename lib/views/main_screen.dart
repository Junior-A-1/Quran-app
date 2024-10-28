import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_app/provider/surah_provider.dart';
import 'package:quran_app/views/widgets/header_widget.dart';
import 'package:quran_app/models/surah.dart';
import 'package:shimmer/shimmer.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahListAsyncValue = ref.watch(surahListProvider);
    final currentSurahIndex = ref.watch(currentSurahIndexProvider);

    void showNextSurah() {
      ref.read(currentSurahIndexProvider.notifier).state++;
    }

    void showPreviousSurah() {
      ref.read(currentSurahIndexProvider.notifier).state--;
    }

    void handleSurahSearch(int surahNumber) {
      final surahList = surahListAsyncValue.asData?.value;
      if (surahList != null &&
          surahNumber > 0 &&
          surahNumber <= surahList.length) {
        ref.read(currentSurahIndexProvider.notifier).state = surahNumber - 1;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Surah $surahNumber not found')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          HeaderWidget(onSearch: handleSurahSearch),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: surahListAsyncValue.when(
              data: (surahs) {
                final surah = surahs[currentSurahIndex];
                return Column(
                  children: [
                    Text(
                      'SURAH ${surah.number} - ${surah.englishName}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      surah.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"${surah.englishNameTranslation}"',
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Revelation Type: ${surah.revelationType}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                );
              },
              loading: () => _buildShimmerHeader(),
              error: (error, _) => Text('Error: $error'),
            ),
          ),
          Expanded(
            child: surahListAsyncValue.when(
              data: (surahs) => ListView.builder(
                itemCount: surahs[currentSurahIndex].ayahs.length,
                itemBuilder: (context, index) {
                  final ayah = surahs[currentSurahIndex].ayahs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ayah.text,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildDetailText(
                                    'Ayah Number: ${ayah.numberInSurah}'),
                                _buildDetailText('Page: ${ayah.page}'),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildDetailText('Juz: ${ayah.juz}'),
                                _buildDetailText('Ruku: ${ayah.ruku}'),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildDetailText('Manzil: ${ayah.manzil}'),
                                _buildDetailText(
                                    'Hizb Quarter: ${ayah.hizbQuarter}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              loading: () => _buildShimmerAyahList(),
              error: (error, _) => Text('Error: $error'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentSurahIndex > 0 ? showPreviousSurah : null,
                  child: const Text('Previous Surah'),
                ),
                ElevatedButton(
                  onPressed: surahListAsyncValue.asData?.value.length != null &&
                          currentSurahIndex <
                              (surahListAsyncValue.asData!.value.length - 1)
                      ? showNextSurah
                      : null,
                  child: const Text('Next Surah'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerHeader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            height: 24,
            width: 200,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Container(
            height: 20,
            width: 150,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Container(
            height: 16,
            width: 180,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerAyahList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Container(
              height: 100,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 20,
                        width: double.infinity,
                        color: Colors.white),
                    const SizedBox(height: 8),
                    Container(height: 16, width: 150, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
    );
  }
}
