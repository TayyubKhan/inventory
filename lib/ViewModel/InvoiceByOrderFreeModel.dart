import 'package:flutter/material.dart';
import '../Model/CustomerAndProductModel.dart';

class InvoiceProvider extends ChangeNotifier {
  double _total_price = 0;
  List<Product> _selectedProducts = [];
  List<dynamic> _jsonProductsResponse = [];
  List<dynamic> _jsonCustomersResponse = [];
  String _selectedProduct = 'Select';
  String _selectedCustomer = 'Select';
  bool _isLoading = false;
  bool _isLoading2 = false;
  TextEditingController _customerAddressController = TextEditingController();
  TextEditingController _customerPhoneController = TextEditingController();

  List<Product> get selectedProducts => _selectedProducts;
  double get total_price => _total_price;
  List<dynamic> get jsonProductsResponse => _jsonProductsResponse;
  List<dynamic> get jsonCustomersResponse => _jsonCustomersResponse;
  String get selectedProduct => _selectedProduct;
  String get selectedCustomer => _selectedCustomer;
  bool get isLoading => _isLoading;
  bool get isLoading2 => _isLoading2;
  TextEditingController get customerAddressController =>
      _customerAddressController;
  TextEditingController get customerPhoneController => _customerPhoneController;

  set selectedProducts(List<Product> value) {
    _selectedProducts = value;
    notifyListeners();
  }

  set jsonProductsResponse(List<dynamic> value) {
    _jsonProductsResponse = value;
    notifyListeners();
  }

  double totalprice() {
    _total_price = _selectedProducts.fold(
      0.0,
      (previousValue, product) => previousValue + product.totalPrice(),
    );
    notifyListeners();
    return _total_price;
  }

  set jsonCustomersResponse(List<dynamic> value) {
    _jsonCustomersResponse = value;
    notifyListeners();
  }

  set selectedProduct(String value) {
    _selectedProduct = value;
    notifyListeners();
  }

  void loading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void loading2() {
    _isLoading2 = !_isLoading2;
    notifyListeners();
  }

  set selectedCustomer(String value) {
    _selectedCustomer = value;
    notifyListeners();
  }
}
