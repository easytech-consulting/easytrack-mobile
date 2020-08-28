class Category {
  final int id;
  final String name;

  Category({
    this.name,
    this.id,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.parse(json['category_id'].toString()),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'category_id': id.toString(),
        'name': name.toString(),
      };
}
