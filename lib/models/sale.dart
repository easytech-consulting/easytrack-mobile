class Sale {
  final int id;
  final bool isActive;
  final int status;
  final double shippingCost;
  final String code;
  final String saleNote;
  final String sellerNote;
  final String payingMethod;
  final String createdAt;
  final String deleteAt;

  Sale(
      {this.createdAt,
      this.deleteAt,
      this.id,
      this.code,
      this.isActive,
      this.shippingCost,
      this.status,
      this.saleNote,
      this.sellerNote,
      this.payingMethod});

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: int.parse(json['id'].toString()),
      isActive: int.parse(json['is_active'].toString()) == 1 ? true : false,
      status: json['status'],
      shippingCost: json['shipping_cost'],
      saleNote: json['sale_note'],
      code: json['code'],
      sellerNote: json['seller_note'],
      payingMethod: json['paying_method'],
      createdAt: json['created_at'],
      deleteAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'is_active': isActive ? '1' : '0',
        'status': status.toString(),
        'shipping_cost': shippingCost.toString(),
        'sale_note': saleNote,
        'seller_note': sellerNote,
        'code': code,
        'paying_method': payingMethod,
        'created_at': createdAt,
        'deleted_at': deleteAt
      };
}
