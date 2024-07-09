import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginRepo{
  Future<Map<String, dynamic>> loginRepo(
      String url, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to login (${response.statusCode})');
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

