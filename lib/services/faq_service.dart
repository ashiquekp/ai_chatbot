import 'dart:convert';
import 'package:flutter/services.dart';

class FAQService {
  List<Map<String, String>> _faqs = [];

  Future<void> load() async {
    final raw = await rootBundle.loadString('assets/faq.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    _faqs = (json['faqs'] as List).map((e) => {
      "q": (e["q"] ?? "").toString().toLowerCase(),
      "a": (e["a"] ?? "").toString(),
    }).toList();
  }

  Future<String> answer(String input) async {
    if (_faqs.isEmpty) await load();
    final q = input.toLowerCase().trim();
    // exact
    for (final item in _faqs) {
      if (item["q"] == q) return item["a"]!;
    }
    // contains
    for (final item in _faqs) {
      if (q.contains(item["q"]!)) return item["a"]!;
    }
    return "I don't know that yet. Try online mode!";
  }
}
