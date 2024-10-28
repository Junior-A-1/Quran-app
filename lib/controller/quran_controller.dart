import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:quran_app/models/ayah.dart';

import 'package:quran_app/models/surah.dart';

final quranProvider = StateNotifierProvider<QuranController, QuranState>(
  (ref) => QuranController(),
);

class QuranState {
  final List<Surah> surahs;
  final List<Ayah> ayahs;
  final int currentSurah;
  final int currentAyahPage;
  final bool isLoading;

  QuranState({
    this.surahs = const [],
    this.ayahs = const [],
    this.currentSurah = 1,
    this.currentAyahPage = 0,
    this.isLoading = true,
  });

  QuranState copyWith({
    List<Surah>? surahs,
    List<Ayah>? ayahs,
    int? currentSurah,
    int? currentAyahPage,
    bool? isLoading,
  }) {
    return QuranState(
      surahs: surahs ?? this.surahs,
      ayahs: ayahs ?? this.ayahs,
      currentSurah: currentSurah ?? this.currentSurah,
      currentAyahPage: currentAyahPage ?? this.currentAyahPage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class QuranController extends StateNotifier<QuranState> {
  QuranController() : super(QuranState()) {
    fetchSurahs();
  }

  final int ayahsPerPage = 8;
  Future<void> fetchSurahs() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await http
          .get(Uri.parse('https://api.alquran.cloud/v1/quran/ur.jhaladhry'));

      // Log the response body
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Ensure `data` and `surahs` exist before proceeding
        if (data['data'] != null && data['data']['surahs'] is List) {
          final List<Surah> surahs = (data['data']['surahs'] as List)
              .map((json) => Surah.fromJson(json))
              .toList();
          state = state.copyWith(surahs: surahs, isLoading: false);
          print("Surahs loaded: ${surahs.length}");
        } else {
          print("Unexpected JSON structure: ${data['data']}");
        }
      } else {
        print("Failed to load data: ${response.body}");
      }
    } catch (e) {
      print("Error in fetchSurahs: $e"); // Log any errors
    }
  }

  Future<void> fetchAyahs(int surahNumber) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await http.get(Uri.parse(
          'https://api.alquran.cloud/v1/surah/$surahNumber/ur.jhaladhry'));

      print("Response body: ${response.body}");
      print("Response status: ${response.statusCode} for Surah $surahNumber");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final ayahData = data['data']['ayahs'];
        final ayahs =
            ayahData.map<Ayah>((json) => Ayah.fromJson(json)).toList();
        state =
            state.copyWith(ayahs: ayahs, currentAyahPage: 0, isLoading: false);
        print("Ayahs loaded: ${ayahs.length}");
      } else {
        print("Failed to load Ayahs: ${response.body}");
      }
    } catch (e) {
      print("Error in fetchAyahs: $e");
    }
  }

  List<Ayah> get paginatedAyahs {
    int start = state.currentAyahPage * ayahsPerPage;
    int end = start + ayahsPerPage;
    return state.ayahs
        .sublist(start, end > state.ayahs.length ? state.ayahs.length : end);
  }

  void goToNextPage() {
    if ((state.currentAyahPage + 1) * ayahsPerPage < state.ayahs.length) {
      state = state.copyWith(currentAyahPage: state.currentAyahPage + 1);
    } else if (state.currentSurah < state.surahs.length) {
      fetchAyahs(state.currentSurah + 1);
      state = state.copyWith(currentSurah: state.currentSurah + 1);
    }
  }

  void selectSurah(int surahNumber) {
    fetchAyahs(surahNumber);
    state = state.copyWith(currentSurah: surahNumber);
  }
}
