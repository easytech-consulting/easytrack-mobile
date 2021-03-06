class UserWithId {
  final int id;
  final String name;
  final String email;
  final String address;
  final String username;
  final String tel;
  final String photo;

  UserWithId(
      {this.id,
      this.name,
      this.email,
      this.address,
      this.username,
      this.tel,
      this.photo});

  factory UserWithId.fromJson(Map<String, dynamic> json) {
    return UserWithId(
        id: int.parse(json['id'].toString()),
        name: json['name'],
        email: json['email'],
        address: json['address'],
        username: json['username'],
        tel: json['phone'],
        photo: json['photo']);
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'name': name.toString(),
        'email': email.toString(),
        'address': address.toString(),
        'username': username.toString(),
        'phone': tel.toString(),
        'photo': photo.toString()
      };
}
