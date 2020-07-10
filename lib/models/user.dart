class User {
  final int id;
  final String name;
  final String email;
  final String address;
  final String username;
  final String isAdmin;
  final String cniNumber;
  final String photo;

  User(
      {this.id,
      this.name,
      this.email,
      this.address,
      this.username,
      this.isAdmin,
      this.cniNumber,
      this.photo});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: int.parse(json['user_id'].toString()),
        name: json['name'],
        email: json['email'],
        address: json['address'],
        username: json['username'],
        isAdmin: json['is_admin'],
        cniNumber: json['cni_number'],
        photo: json['photo']);
  }

  Map<String, dynamic> toJson() => {
        'user_id': id.toString(),
        'name': name.toString(),
        'email': email.toString(),
        'address': address.toString(),
        'username': username.toString(),
        'is_admin': isAdmin.toString,
        'cni_number': cniNumber.toString(),
        'photo': photo.toString()
      };
}
