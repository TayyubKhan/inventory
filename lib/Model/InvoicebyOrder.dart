class Order {
  final dynamic id;
  final dynamic orderId;
  final dynamic discount;
  final dynamic subtotal;
  final dynamic grandTotal;
  final dynamic customerName;
  final dynamic customerAddress;
  final dynamic customerPhone;
  final dynamic date;
  final dynamic user;

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
  final dynamic id;
  final String name;
  final dynamic unitPrice;
  final dynamic quantity;
  final dynamic totalPrice;
  final dynamic orderId;
  final dynamic productId;
  final dynamic date;

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
