
class Order {
  final String id;
  final String orderId;
  final String discount;
  final String subtotal;
  final String grandTotal;
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final String date;
  final String user;

  Order({
    required this.id,
    required this.orderId,
    required this.discount,
    required this.subtotal,
    required this.grandTotal,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.date,
    required this.user,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      discount: json['discount'] ?? '',
      subtotal: json['subtotal'] ?? '',
      grandTotal: json['grand_total'] ?? '',
      customerName: json['c_name'] ?? '',
      customerAddress: json['c_address'] ?? '',
      customerPhone: json['c_phone'] ?? '',
      date: json['date'] ?? '',
      user: json['user'] ?? '',
    );
  }
}

class Product {
  final String id;
  final String name;
  final String unitPrice;
  final String quantity;
  final String totalPrice;
  final String orderId;
  final String productId;
  final String date;

  Product({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
    required this.orderId,
    required this.productId,
    required this.date,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['p_name'] ?? '',
      unitPrice: json['p_unit_price'] ?? '',
      quantity: json['p_quantity'] ?? '',
      totalPrice: json['p_total_price'] ?? '',
      orderId: json['order_id'] ?? '',
      productId: json['p_id'] ?? '',
      date: json['date'] ?? '',
    );
  }
}