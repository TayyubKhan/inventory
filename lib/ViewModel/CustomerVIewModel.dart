import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/CustomerDbHelper.dart';
import '../Model/customer_model.dart';

class CustomerProvider extends ChangeNotifier {
  List<CustomerModel> _filteredCustomers = [];
  String _searchQuery = '';
  final CustomerDatabaseHelper _dbHelper = CustomerDatabaseHelper();
  List<CustomerModel> _customers = [];
  String get searchQuery => _searchQuery;
  List<CustomerModel> get customers => _customers;
  List<CustomerModel> get filteredCustomers => _filteredCustomers;

  Future<List<CustomerModel>> fetchCustomers(String query) async {
    _customers = await _dbHelper.getCustomers();
    if (_customers.isNotEmpty) {
      if (query.isEmpty) {
        _filteredCustomers = _customers;
        return _customers;
      } else {
        return _customers;
      }
    } else {
      return await getFromApi();
    }
  }

  Future<List<CustomerModel>> getFromApi() async {
    const apiUrl =
        'https://a.thekhantraders.com/api/get_customers.php?type=get';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        _customers =
            jsonResponse.map((data) => CustomerModel.fromJson(data)).toList();
        // Save customers to the local database
        await _dbHelper.deleteCustomers(); // Clear existing data
        for (CustomerModel customer in _customers) {
          await _dbHelper.insertCustomer(customer);
        }
        notifyListeners();
        _filteredCustomers = _customers;
        return _filteredCustomers;
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

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _filteredCustomers = _customers.where((customer) {
      return customer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          customer.address.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
    notifyListeners();
  }
}
