import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/CustomerAndProductModel.dart';
import '../Model/localHelper.dart';

class AddInvoiceRepo {
  final LocalDatabaseHelper _localDb = LocalDatabaseHelper();

  Future<void> addInvoiceApi({
    required dynamic cName,
    required dynamic cAddress,
    required dynamic cPhone,
    required dynamic subtotal,
    required List<Product> products,
  }) async {
    final sp = await SharedPreferences.getInstance();
    var formData = {
      'c_name': cName,
      'c_address': cAddress,
      'c_phone': cPhone,
      'discount': '0',
      'subtotal': subtotal.toString(),
      'grand_total': subtotal.toString(),
      for (int i = 0; i < products.length; i++) ...{
        'p_id[$i]': products[i].id.toString(),
        'p_name[$i]': products[i].name.toString(),
        'p_unit_price[$i]': products[i].price.toString(),
        'p_quantity[$i]': products[i].quantity.toString(),
        'p_total_price[$i]': products[i].totalPrice().toString(),
      },
      'user': sp.getString('userId').toString()
    };
    var formData2 = {
      'product_length': products.length.toString(),
      'c_name': cName,
      'c_address': cAddress,
      'c_phone': cPhone,
      'discount': '0',
      'subtotal': subtotal.toString(),
      'grand_total': subtotal.toString(),
      for (int i = 0; i < products.length; i++) ...{
        'p_id[$i]': products[i].id.toString(),
        'p_name[$i]': products[i].name.toString(),
        'p_unit_price[$i]': products[i].price.toString(),
        'p_quantity[$i]': products[i].quantity.toString(),
        'p_total_price[$i]': products[i].totalPrice().toString(),
      },
      'user': sp.getString('userId').toString()
    };
    try {
      final response = await http.post(
        Uri.parse('https://a.thekhantraders.com/api/add_invoice.php?type=get'),
        body: formData,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Handle successful response
      } else {
        throw Exception('Failed to send invoice data: ${response.statusCode}');
      }
    } on TimeoutException {
      // Save data locally if the request times out
      await _localDb.insertInvoice(jsonEncode(formData2));
      throw Exception(
          'Request timed out. Invoice will sync when Internet is connected');
    } on http.ClientException catch (_) {
      // Save data locally if there's an issue with the request
      await _localDb.insertInvoice(jsonEncode(formData2));
      throw Exception('Invoice will sync when Internet is connected');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (error) {
      print(error);
      throw Exception('Error: $error');
    }
  }
}

class SyncService {
  final AddInvoiceRepo _invoiceRepo = AddInvoiceRepo();
  final LocalDatabaseHelper _localDb = LocalDatabaseHelper();

  Future<void> syncInvoices() async {
    try {
      List<Map<String, dynamic>> invoices = await _localDb.getInvoices();
      for (var invoice in invoices) {
        final data = jsonDecode(invoice['data']);
        List<Product> products = [];
        int i = 0;
        while (data.containsKey('p_id[$i]')) {
          products.add(Product(
            id: data['p_id[$i]'].toString(),
            name: data['p_name[$i]'],
            price: double.parse(data['p_unit_price[$i]']),
            quantity: int.parse(data['p_quantity[$i]']),
          ));
          i++;
        }
        await _invoiceRepo.addInvoiceApi(
          cName: data['c_name'],
          cAddress: data['c_address'],
          cPhone: data['c_phone'],
          subtotal: double.parse(data['subtotal'].toString()),
          products: products,
        );
        // Delete successfully synced invoice
        await _localDb.deleteInvoice(invoice['id']);
      }
    } catch (error) {
      print('Failed to sync invoices: $error');
    }
  }
}
