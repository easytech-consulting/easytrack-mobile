class Product {
  final int id;
  final String name;
  final String code;
  final String description;
  final String brand;
  final bool isActive;
  final String createdAt;
  final String deleteAt;
  final int cost;
  final int price;
  final int qty;
  final int qtyAlert;
  final bool hasPromotion;
  final int promotionPrice;
  final String promotionStart;
  final String promotionEnd;

  Product(
      {this.id,
      this.name,
      this.code,
      this.description,
      this.brand,
      this.isActive,
      this.createdAt,
      this.deleteAt,
      this.cost,
      this.price,
      this.qty,
      this.qtyAlert,
      this.hasPromotion,
      this.promotionPrice,
      this.promotionStart,
      this.promotionEnd});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: int.parse(json['id'].toString()),
        name: json['name'],
        code: json['code'],
        description: json['description'],
        brand: json['brand'],
        isActive: json['is_active'] == 1 ? true : false,
        createdAt: json['created_at'],
        deleteAt: json['deleted_at'],
        cost: json['pivot']['cost'],
        price: json['pivot']['price'],
        qty: json['pivot']['qty'],
        qtyAlert: json['pivot']['qty_alert'],
        hasPromotion: json['pivot']['promotion'] == 1 ? true : false,
        promotionPrice: json['pivot']['promotion'] == 0
            ? 0
            : json['pivot']['promotion_price'],
        promotionStart: json['pivot']['promotion_start'],
        promotionEnd: json['pivot']['promotion_end']);
  }
}
