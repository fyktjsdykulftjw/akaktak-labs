class Quote {
  final String text;
  final String author;
  final DateTime? timestamp;

  Quote({
    required this.text,
    required this.author,
    this.timestamp,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['content'] as String,
      author: json['author'] as String,
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'author': author,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
