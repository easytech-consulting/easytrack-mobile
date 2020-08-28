class SupplierWithId {
  final int id;
  final String email;
  final String companyName;
  final String town;
  final String postalCode;
  final String street;
  final bool isActive;
  final String createdAt;
  final String deletedAt;
  final String tel1;
  final String tel2;
  final String name;

  SupplierWithId(
      {this.companyName,
      this.town,
      this.postalCode,
      this.street,
      this.isActive,
      this.createdAt,
      this.deletedAt,
      this.id,
      this.email,
      this.name,
      this.tel1,
      this.tel2});

  factory SupplierWithId.fromJson(Map<String, dynamic> json) {
    return SupplierWithId(
        id: int.parse(json['id'].toString()),
        email: json['email'],
        tel1: json['phone1'],
        tel2: json['phone2'],
        name: json['name'],
        companyName: json['company_name'],
        createdAt: json['created_at'],
        deletedAt: json['deleted_at'],
        isActive: json['is_active'] == 1 ? true : false,
        postalCode: json['postal_code'],
        street: json['street'],
        town: json['town']);
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'email': email.toString(),
        'phone1': tel1.toString(),
        'phone2': tel2.toString(),
        'name': name.toString(),
      };
}
