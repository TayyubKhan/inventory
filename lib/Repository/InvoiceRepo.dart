import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/DatabaseHelper.dart';
import '../Model/InvoiceModel.dart';

class InvoiceRepo {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Invoices>> fetchInvoices() async {
    List<Invoices> localInvoices = await _dbHelper.getInvoices();
    if (localInvoices.isNotEmpty) {
      // Return local data if available
      return localInvoices;
    }
    final sp = await SharedPreferences.getInstance();
    // If no local data or we prefer to fetch fresh data, attempt API call
    try {
      final response = await http.get(Uri.parse(
          'https://a.thekhantraders.com/api/get_invoices.php?type=get&user=${sp.getString('userId')}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Invoices> invoices =
            data.map((item) => Invoices.fromJson(item)).toList();

        // Save invoices to the local database
        await _dbHelper.deleteInvoices(); // Clear existing data
        for (Invoices invoice in invoices) {
          await _dbHelper.insertInvoice(invoice);
        }
        return invoices;
      } else {
        // Return local data if API call fails
        return localInvoices;
      }
    } catch (error) {
      // Return local data if there's an error during API call
      return localInvoices;
    }
  }

  Future<List<Invoices>> refreshInvoices() async {
    try {
      final response = await http.get(Uri.parse(
          'https://a.thekhantraders.com/api/get_invoices.php?type=get&user=1'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Invoices> invoices =
            data.map((item) => Invoices.fromJson(item)).toList();

        // Save invoices to the local database
        await _dbHelper.deleteInvoices(); // Clear existing data
        for (Invoices invoice in invoices) {
          await _dbHelper.insertInvoice(invoice);
        }
        return invoices;
      } else {
        throw Exception('Failed to load invoices from API');
      }
    } catch (error) {
      throw Exception('Error refreshing invoices: $error');
    }
  }
}
