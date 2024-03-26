class Product {
  Product({
    required this.code,
    required this.name,
    required this.quantity,
    required this.productId,
  });

  final String? code;
  final String? name;
  final int? quantity;
  final String? productId;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      code: json["code"] ?? '',
      name: json["name"] ?? '',
      quantity: json["quantity"] ?? 0,
      productId: json["productId"] ?? '',
    );
  }

  toJson() {}
}
