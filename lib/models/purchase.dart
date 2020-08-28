class Purchase {
  final int id;
  final bool isActive;
  final bool alreadyDelivered;
  final double shippingCost;
  final String code;
  final String payingMethod;
  final String purchaseText;
  final String createdAt;
  final String deleteAt;

  Purchase(
      {this.createdAt,
      this.deleteAt,
      this.id,
      this.isActive,
      this.code,
      this.shippingCost,
      this.purchaseText,
      this.alreadyDelivered,
      this.payingMethod});

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: int.parse(json['id'].toString()),
      isActive: int.parse(json['is_active'].toString()) == 1 ? true : false,
      alreadyDelivered:
          int.parse(json['status'].toString()) == 1 ? true : false,
      shippingCost: json['shipping_cost'] == null
          ? 0.0
          : double.parse(json['shipping_cost'].toString()),
      payingMethod: json['paying_method'],
      code: json['code'],
      purchaseText: json['purchase_text'],
      createdAt: json['created_at'],
      deleteAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'is_active': isActive ? '1' : '0',
        'status': alreadyDelivered ? '1' : '0',
        'shipping_cost': shippingCost.toString(),
        'code': code.toString(),
        'paying_method': payingMethod.toString(),
        'purchase_text': purchaseText.toString(),
        'created_at': createdAt.toString(),
        'deleted_at': deleteAt.toString()
      };
}
