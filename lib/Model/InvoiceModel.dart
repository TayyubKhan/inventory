class Invoices {
  String? id;
  String? orderId;
  String? discount;
  String? subtotal;
  String? grandTotal;
  String? cName;
  String? cAddress;
  String? cPhone;
  String? date;
  String? user;

  Invoices({
    this.id,
    this.orderId,
    this.discount,
    this.subtotal,
    this.grandTotal,
    this.cName,
    this.cAddress,
    this.cPhone,
    this.date,
    this.user,
  });

  factory Invoices.fromJson(Map<String, dynamic> json) {
    return Invoices(
      id: json['id']?.toString(),
      orderId: json['order_id'],
      discount: json['discount'],
      subtotal: json['subtotal'],
      grandTotal: json['grand_total'],
      cName: json['c_name'],
      cAddress: json['c_address'],
      cPhone: json['c_phone'],
      date: json['date'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'discount': discount,
      'subtotal': subtotal,
      'grand_total': grandTotal,
      'c_name': cName,
      'c_address': cAddress,
      'c_phone': cPhone,
      'date': date,
      'user': user,
    };
  }
}
