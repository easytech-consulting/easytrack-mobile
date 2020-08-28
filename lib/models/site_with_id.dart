class SiteWithId {
  final int id;
  final String email;
  final String name;
  final String slug;
  final String createdAt;
  final String deleteAt;
  final String tel1;
  final String tel2;
  final String town;
  final String street;

  SiteWithId(
      {this.name,
      this.slug,
      this.createdAt,
      this.deleteAt,
      this.id,
      this.email,
      this.street,
      this.tel1,
      this.tel2,
      this.town});

  factory SiteWithId.fromJson(Map<String, dynamic> json) {
    return SiteWithId(
        id: int.parse(json['id'].toString()),
        name: json['name'],
        slug: json['slug'],
        createdAt: json['created_at'],
        email: json['email'],
        tel1: json['phone1'],
        tel2: json['phone2'],
        street: json['street'],
        town: json['town'],
        deleteAt: json['deleteAt']);
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'name': name.toString(),
        'email': email.toString(),
        'tel1': tel1.toString(),
        'tel2': tel2.toString(),
        'street': street.toString(),
        'town': town.toString(),
        'created_at': createdAt.toString(),
        'deleted_at': deleteAt.toString(),
      };
}
