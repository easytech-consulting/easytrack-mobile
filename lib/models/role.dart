class Role {
  final int id;
  final String name;
  final String slug;
  final String description;

  Role({this.id, this.name, this.slug, this.description});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
        id: int.parse(json['role_id'].toString()),
        name: json['name'],
        slug: json['slug'],
        description: json['description']);
  }

  Map<String, dynamic> toJson() => {
        'role_id': id.toString(),
        'name': name.toString(),
        'slug': slug.toString(),
        'description': description.toString()
      };
}
