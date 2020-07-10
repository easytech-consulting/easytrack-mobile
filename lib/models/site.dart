class Site {
  final int id;
  final String email;
  final String tel1;
  final String tel2;
  final String town;
  final String street;

  Site({this.id, this.email, this.street, this.tel1, this.tel2, this.town});

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
        id: int.parse(json['site_id'].toString()),
        email: json['email'],
        tel1: json['tel1'],
        tel2: json['tel2'],
        street: json['street'],
        town: json['town']);
  }

  Map<String, dynamic> toJson() => {
        'site_id': id.toString(),
        'email': email.toString(),
        'tel1': tel1.toString(),
        'tel2': tel2.toString(),
        'street': street.toString(),
        'town': town.toString()
      };
}
