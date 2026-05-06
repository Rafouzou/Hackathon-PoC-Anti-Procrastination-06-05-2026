class VerifiMessage {
  final String id;
  final String senderUid;
  final String senderName;
  final String text;
  final String? imageUrl;
  final DateTime timestamp;

  VerifiMessage({
    required this.id,
    required this.senderUid,
    required this.senderName,
    required this.text,
    this.imageUrl,
    required this.timestamp,
  });

  factory VerifiMessage.fromJson(Map<String, dynamic> json) {
    return VerifiMessage(
      id: json['id'] as String,
      senderUid: json['senderUid'] as String,
      senderName: json['senderName'] as String,
      text: json['text'] as String,
      imageUrl: json['imageUrl'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderUid': senderUid,
      'senderName': senderName,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
