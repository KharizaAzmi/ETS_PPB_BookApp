class Book {
  int id;
  String image;
  String title;
  DateTime date;
  String description;

  Book({required this.id, required this.image, required this.title, required this.date, required this.description});

  factory Book.fromSqfliteDatabase(Map<String, dynamic> map) => Book(
    id: map['id']?.toInt() ?? 0,
    image: map['image'] ?? '',
    title: map['title'] ?? '',
    date: DateTime(map['date']),
    description: map['description'] ?? '',
  );
}