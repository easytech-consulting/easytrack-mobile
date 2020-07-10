class Supplier {
  final int id;
  final String email;
  final String tel1;
  final String tel2;
  final String name;

  Supplier({this.id, this.email, this.name, this.tel1, this.tel2});

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
        id: int.parse(json['supplier_id'].toString()),
        email: json['email'],
        tel1: json['tel1'],
        tel2: json['tel2'],
        name: json['name']);
  }

  Map<String, dynamic> toJson() => {
        'supplier_id': id.toString(),
        'email': email.toString(),
        'tel1': tel1.toString(),
        'tel2': tel2.toString(),
        'name': name.toString(),
      };
}
