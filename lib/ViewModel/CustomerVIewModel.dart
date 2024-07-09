import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/CustomerDbHelper.dart';
import '../Model/customer_model.dart';
class CustomerProvider extends ChangeNotifier {
  final CustomerDatabaseHelper _dbHelper = CustomerDatabaseHelper();
  List<CustomerModel> _customers = [];
  int _pageNumber = 1;
  bool _loading = false;

  List<CustomerModel> get customers => _customers;
  bool get loading => _loading;

  Future<List<CustomerModel>> fetchCustomers({bool refresh = false}) async {
    if (refresh) {
      _pageNumber = 1;
      _customers.clear();
    }

    try {
      _loading = true;
      notifyListeners();

      // Simulate API call with pagination
      final apiUrl = 'https://a.thekhantraders.com/api/get_customers.php?type=get&page=$_pageNumber';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        _customers.addAll(jsonResponse.map((data) => CustomerModel.fromJson(data)));
        _pageNumber++;

        // Save to local database
        if (refresh) {
          await _dbHelper.deleteCustomers();
        }
        for (CustomerModel customer in jsonResponse) {
          await _dbHelper.insertCustomer(customer);
        }

        _loading = false;
        notifyListeners();

        return _customers;
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (error) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }
}
