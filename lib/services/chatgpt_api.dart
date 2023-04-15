import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatGptApi {
  Future<String> sendMessage(String text) async {
    final uri = Uri.parse('https://api.openai.com/v1/completions');

    final request = {
      "model": "text-davinci-003",
      "prompt": text,
      "max_tokens": 100,
      "temperature": 0
    };

    final response = await http.post(
      uri,
      headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${dotenv.env['OPENAI_API_KEY']}',
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse['choices'][0]['text'];
    } else {
      throw Exception('Failed to generate response: ${response.reasonPhrase}');
    }
  }
}
