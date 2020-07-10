class Snack {
  final int id;
  final String name;
  final String slug;
  final String email;
  final String tel1;
  final String tel2;
  final String town;
  final String street;
  final String logo;

  Snack(
      {this.id,
      this.name,
      this.slug,
      this.email,
      this.tel1,
      this.tel2,
      this.town,
      this.street,
      this.logo});

  factory Snack.fromJson(Map<String, dynamic> json) {
    return Snack(
      id: json['snack_id'],
      name: json['name'],
      slug: json['slug'],
      email: json['email'],
      tel1: json['tel1'],
      tel2: json['tel2'],
      town: json['town'],
      street: json['street'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() => {
        'snack_id': id.toString(),
        'name': name.toString(),
        'slug': slug.toString(),
        'email': email.toString(),
        'tel1': tel1.toString(),
        'tel2': tel2.toString(),
        'town': town.toString(),
        'street': street.toString(),
        'logo': logo.toString(),
      };
}
