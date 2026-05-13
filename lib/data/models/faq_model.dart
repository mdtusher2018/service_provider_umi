class FaqItem {
  final String id;
  final String question;
  final String answer;

  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory FaqItem.fromJson(Map<String, dynamic> json) => FaqItem(
    id: json['id'] ?? "",
    question: json['question'] ?? "",
    answer: json['answer'] ?? "",
  );
}
