enum Sender { user, bot }

class Message {
  final String id;
  final Sender sender;
  final String text;
  final DateTime timestamp;

  Message({required this.id, required this.sender, required this.text, required this.timestamp});

  Map<String, dynamic> toJson() => {
    "id": id,
    "sender": sender.name,
    "text": text,
    "timestamp": timestamp.toIso8601String(),
  };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"] as String,
    sender: (json["sender"] as String) == "user" ? Sender.user : Sender.bot,
    text: json["text"] as String? ?? "",
    timestamp: DateTime.parse(json["timestamp"] as String),
  );
}
