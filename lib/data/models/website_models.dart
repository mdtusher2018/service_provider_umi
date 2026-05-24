class WebsiteServiceModel {
  final String name;
  final String description;
  final String image;

  const WebsiteServiceModel({
    required this.name,
    required this.description,
    required this.image,
  });

  factory WebsiteServiceModel.fromJson(Map<String, dynamic> json) {
    return WebsiteServiceModel(
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String? ?? '',
    );
  }
}

class AboutUsModel {
  final String image;
  final String title;
  final String content; // raw HTML string
  final String buttonText;
  final String buttonLink;

  const AboutUsModel({
    required this.image,
    required this.title,
    required this.content,
    required this.buttonText,
    required this.buttonLink,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) {
    return AboutUsModel(
      image: json['image'] as String? ?? '',
      title: json['title'] as String,
      content: json['content'] as String,
      buttonText: json['buttonText'] as String? ?? '',
      buttonLink: json['buttonLink'] as String? ?? '#',
    );
  }
}
