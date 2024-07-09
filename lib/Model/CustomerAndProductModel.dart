class Customer {
  int? id;
  String? name;
  String? owner;
  String? phone;
  String? cnic;
  String? address;
  String? area;
  String? day;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.cnic,
    required this.area,
    required this.day,
  });
}

class Product {
  final String id;
  final String name;
  final double price;
  int quantity; // Add quantity field

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1, // Default quantity is 1
  });

  // Calculate total price based on quantity
  double totalPrice() {
    return price * quantity;
  }
}
