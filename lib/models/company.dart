class Company {
  final int id;
  final String email;
  final String name;
  final String slug;
  final String createdAt;
  final String deleteAt;
  final String tel1;
  final String tel2;
  final String photo;
  final String town;
  final bool isActive;
  final String street;

  Company(
      {this.name,
      this.slug,
      this.createdAt,
      this.deleteAt,
      this.id,
      this.email,
      this.street,
      this.photo,
      this.tel1,
      this.tel2,
      this.isActive,
      this.town});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
        id: int.parse(json['id'].toString()),
        name: json['name'],
        slug: json['slug'],
        createdAt: json['created_at'],
        email: json['email'],
        tel1: json['phone1'],
        tel2: json['phone2'],
        street: json['street'],
        town: json['town'],
        photo: json['photo'],
        isActive: json['is_active'] == 1 ? false : true,
        deleteAt: json['deleteAt']);
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'name': name.toString(),
        'email': email.toString(),
        'phone1': tel1.toString(),
        'phone2': tel2.toString(),
        'street': street.toString(),
        'town': town.toString(),
        'created_at': createdAt.toString(),
        'deleted_at': deleteAt.toString(),
        'photo': photo.toString(),
        'is_active': isActive ? 0 : 1
      };
}
