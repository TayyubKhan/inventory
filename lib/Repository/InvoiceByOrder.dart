
import 'dart:convert';

import 'package:http/http.dart' as http;

class InvoiceByOrderRepo {
  Future<dynamic> fetchInvoiceData(String orderId) async {
    try {
      final String apiUrl =
          'https://a.thekhantraders.com/api/get_invoice.php?type=get&order_id=$orderId';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        throw Exception('Failed to load invoice: ${response.statusCode}');
      }
    } on http.ClientException catch (_) {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

}
