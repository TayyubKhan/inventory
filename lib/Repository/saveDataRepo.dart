import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/drop down db.dart';

class SaveDataRepo {
  final dbHelper = DropDownDb();
  Future<void> fetchData() async {
    List<Map<String, dynamic>> customers = await dbHelper.getCustomers();
    List<Map<String, dynamic>> products = await dbHelper.getProducts();
    if (customers.isNotEmpty && products.isNotEmpty) {
    } else {
      fetchData();
    }
  }

  Future<void> callApi() async {
    try {
      final productResponse = await http.get(Uri.parse(
          'https://a.thekhantraders.com/api/get_products.php?type=get'));
      final customerResponse = await http.get(Uri.parse(
          'https://a.thekhantraders.com/api/get_customers.php?type=get'));
      if (productResponse.statusCode == 200 &&
          customerResponse.statusCode == 200) {
        List<dynamic> products = jsonDecode(productResponse.body);
        List<dynamic> customers = jsonDecode(customerResponse.body);
        await saveDataToLocalDatabase(customers, products);
      } else {
        throw Exception('Failed to fetch data');
      }
    } on http.ClientException catch (_) {}
  }

  Future<void> saveDataToLocalDatabase(
      List<dynamic> customers, List<dynamic> products) async {
    await dbHelper.deleteAllCustomers();
    await dbHelper.deleteAllProducts();
    for (var customer in customers) {
      await dbHelper.insertCustomer({
        'id': customer['id'],
        'name': customer['name'],
        'address': customer['address'],
        'phone': customer['phone'],
      });
    }
    for (var product in products) {
      await dbHelper.insertProduct({
        'id': product['id'],
        'name': product['name'],
        'price': product['price'],
      });
    }
  }
}
