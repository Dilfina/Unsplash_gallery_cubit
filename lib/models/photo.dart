class Photo {
  final String id;
  final String url;
  final String author;

  Photo({required this.id, required this.url, required this.author});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      url: json['urls']['regular'],
      author: json['user']['name'],
    );
  }
}
