class Plan {
  final int id;
  final String title;
  final int duration;
  final int price;

  Plan({this.id, this.title, this.duration, this.price});

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['type_id'],
      title: json['title'],
      duration: json['duration'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() => {
        "type_id": id.toString(),
        "title": title.toString(),
        "duration": duration.toString(),
        "price": price.toString()
      };
}
