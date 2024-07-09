import 'package:http/http.dart' as http;
import 'package:inventory_managment/Model/CustomerAndProductModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddInvoiceRepo {
  Future<void> addInvoiceApi({
    required dynamic cName,
    required dynamic cAddress,
    required dynamic cPhone,
    required List<Product> products,
  }) async {
    final sp = await SharedPreferences.getInstance();
    try {
      double subtotal = 0;
      double grandTotal = 0;
      for (int i = 0; i < products.length; i++) {
        subtotal = subtotal +
            double.parse(products[i].totalPrice().toString()) *
                double.parse(products[i].quantity.toString());
      }
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
      print(cName);
      // Send the POST request
      var response = await http.post(
        Uri.parse('https://a.thekhantraders.com/api/add_invoice.php?type=get'),
        body: formData,
      );
      if (response.statusCode == 200) {
      } else {
        throw Exception('Failed to send invoice data: ${response.statusCode}');
      }
    } on http.ClientException catch (_) {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (error) {
      print(error);
      throw Exception('Error: $error');
    }
  }
}
