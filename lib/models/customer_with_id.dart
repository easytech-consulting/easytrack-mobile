class CustomerWithId {
  final int id;
  final String town;
  final String street;
  final String name;
  final String companyName;
  final String email;
  final String phone;
  final String createdAt;
  final String deletedAt;
  final bool isActive;

  CustomerWithId(
      {this.companyName,
      this.email,
      this.phone,
      this.createdAt,
      this.deletedAt,
      this.isActive,
      this.town,
      this.street,
      this.name,
      this.id});

  factory CustomerWithId.fromJson(Map<String, dynamic> json) {
    return CustomerWithId(
        id: int.parse(json['id'].toString()),
        town: json['town'],
        street: json['street'],
        companyName: json['company_name'],
        email: json['email'],
        phone: json['phone'],
        createdAt: json['created_at'],
        deletedAt: json['deleted_at'],
        isActive: json['is_active'] == 1 ? true : false,
        name: json['name']);
  }
}
