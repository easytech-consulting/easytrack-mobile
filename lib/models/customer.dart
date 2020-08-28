class Customer {
  final int id;
  final String town;
  final String street;
  final String name;

  Customer({this.town, this.street, this.name, this.id});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
        id: int.parse(json['customer_id'].toString()),
        town: json['town'],
        street: json['street'],
        name: json['name']);
  }

  Map<String, dynamic> toJson() => {
        'customer_id': id.toString(),
        'street': street.toString(),
        'town': town.toString(),
        'name': name.toString(),
      };
}
