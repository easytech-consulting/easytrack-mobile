class Supplier {
  final int id;
  final String email;
  final String town;
  final String street;
  final bool isActive;
  final String tel1;
  final String tel2;
  final String name;

  Supplier(
      {this.town,
      this.street,
      this.isActive,
      this.id,
      this.email,
      this.name,
      this.tel1,
      this.tel2});

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
        id: int.parse(json['supplier_id'].toString()),
        email: json['email'],
        tel1: json['phone1'],
        tel2: json['phone2'],
        name: json['name'],
        isActive: json['is_active'] == 1 ? true : false,
        street: json['street'],
        town: json['town']);
  }

  Map<String, dynamic> toJson() => {
        'supplier_id': id.toString(),
        'email': email.toString(),
        'phone1': tel1.toString(),
        'phone2': tel2.toString(),
        'town': town.toString(),
        'street': street.toString(),
        'name': name.toString(),
      };
}
