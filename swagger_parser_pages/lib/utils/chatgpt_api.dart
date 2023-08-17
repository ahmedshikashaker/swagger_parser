import 'dart:convert';

import 'package:dio/dio.dart';


// Function to generate unit tests using OpenAI API
Future<String> getSwaggerJson(String url) async {

  final apiUrl = url.endsWith('-json')?url:'$url-json';

  final response = await Dio().get<String>(apiUrl);
  if (response.statusCode == 200) {
    return response.data??'';
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