import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/CustomerDbHelper.dart';
import '../Model/customer_model.dart';

class CustomerProvider extends ChangeNotifier {
  final CustomerDatabaseHelper _dbHelper = CustomerDatabaseHelper();
  List<CustomerModel> _customers = [];

  List<CustomerModel> get customers => _customers;

  Future<List<CustomerModel>> fetchCustomers() async {
    _customers = await _dbHelper.getCustomers();
    if (_customers.isNotEmpty) {
      notifyListeners();
      return _customers;
    } else {
      return await getFromApi();
    }
  }

  Future<List<CustomerModel>> getFromApi() async {
    const apiUrl = 'https://a.thekhantraders.com/api/get_customers.php?type=get';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        _customers =
            jsonResponse.map((data) => CustomerModel.fromJson(data)).toList();
        print(jsonResponse);
        // Save customers to the local database
        await _dbHelper.deleteCustomers(); // Clear existing data
        for (CustomerModel customer in _customers) {
          await _dbHelper.insertCustomer(customer);
        }
        return _customers;
      } else {
        throw Exception('Failed to load customers');
      }
    } on http.ClientException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
