import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final Function(int) onSearch;

  const HeaderWidget({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    void handleSearch() {
      final input = searchController.text;
      if (input.isNotEmpty) {
        final surahNumber = int.tryParse(input);
        if (surahNumber != null) {
          onSearch(surahNumber);
        }
      }
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.20,
      child: Stack(
        children: [
          Image.asset(
            'assets/icons/searchBanner.jpeg',
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 68,
            left: 48,
            child: SizedBox(
              width: 250,
              height: 50,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Surah #',
                  hintStyle: const TextStyle(fontSize: 14, color: Colors.black),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  prefixIcon: Image.asset('assets/icons/searc1.png'),
                  fillColor: const Color.fromARGB(155, 255, 255, 255),
                  filled: true,
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (_) => handleSearch(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
