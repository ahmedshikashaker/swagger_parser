import 'package:http/http.dart' as http;

// Function to generate unit tests using OpenAI API
Future<String> getSwaggerJson(String url) async {
  final apiUrl = url.endsWith('-json') ? url : '$url-json';

  final response = await http.Client().get(
    Uri.parse(apiUrl),
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Access-Control-Allow-Methods': 'GET,PUT,PATCH,POST,DELETE,OPTIONS',
      'Access-Control-Allow-Headers':
          'Origin, X-Requested-With, Content-Type, Accept'
    },
  );
  if (response.statusCode == 200) {
    return response.body ?? '';
  } else {
    throw Exception('Failed to generate tests');
  }
}

bool isURL(String text) {
  try {
    Uri.parse(text);
    return true;
  } catch (e) {
    return false;
  }
}
