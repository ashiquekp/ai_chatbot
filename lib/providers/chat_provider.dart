import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message.dart';
import '../services/faq_service.dart';
import '../services/chatbot_service.dart';

final onlineModeProvider = StateProvider<bool>((_) => false);
final messagesProvider = StateNotifierProvider<ChatNotifier, List<Message>>((ref) {
  return ChatNotifier(ref);
});

class ChatNotifier extends StateNotifier<List<Message>> {
  final Ref ref;
  ChatNotifier(this.ref) : super(const []) {
    _restore();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString("messages");
    if (raw != null) {
      final data = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      state = data.map((e) => Message.fromJson(e)).toList();
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(state.map((m) => m.toJson()).toList());
    await prefs.setString("messages", data);
  }

  Future<void> send(String text) async {
    final user = Message(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      sender: Sender.user,
      text: text,
      timestamp: DateTime.now(),
    );
    state = [...state, user];
    await _persist();

    final isOnline = ref.read(onlineModeProvider);
    final typing = Message(
      id: "${user.id}-typing",
      sender: Sender.bot,
      text: "typing...",
      timestamp: DateTime.now(),
    );
    state = [...state, typing];

    late final String reply;
    if (isOnline) {
      reply = await ChatbotService.reply(text);
    } else {
      reply = await FAQService().answer(text);
    }
    state = [
      for (final m in state) if (m.id == typing.id) Message(id: typing.id, sender: Sender.bot, text: reply, timestamp: DateTime.now()) else m
    ];
    await _persist();
  }

  Future<void> clear() async {
    state = const [];
    await _persist();
  }
}
