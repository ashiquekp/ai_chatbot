import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  static String baseUrl = "https://api.openai.com/v1/chat/completions";
  static String apiKey = ""; // <- set your key or keep empty to simulate

  static Future<String> reply(String prompt) async {
    if (apiKey.isEmpty) {
      return "Online mode demo: (no API key) — you said: $prompt";
    }
    final body = {
      "model": "gpt-4o-mini",
      "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": prompt}
      ],
    };
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final content = json["choices"][0]["message"]["content"] as String?;
      return content ?? "No response.";
    } else {
      return "Error: ${res.statusCode}";
    }
  }
}
