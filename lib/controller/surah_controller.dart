import 'package:http/http.dart' as http;
import 'package:quran_app/models/surah.dart';
import 'dart:convert';

class SurahController {
  Future<List<Surah>> getSurahNames() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.alquran.cloud/v1/quran/ur.jhaladhry'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        List<dynamic> surahList = jsonData['data']['surahs'];
        return surahList.map((surahJson) => Surah.fromJson(surahJson)).toList();
      } else {
        throw Exception('Failed to load Surahs');
      }
    } catch (e) {
      throw Exception('Error fetching Surahs: $e');
    }
  }
}
