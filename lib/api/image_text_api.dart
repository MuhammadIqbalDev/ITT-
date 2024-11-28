
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class APIService {
  static Future<List<int>> loadImageBytes(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      return await file.readAsBytes();
    } else {
      throw Exception('No image selected.');
    }
  }

  static Future<String> getCaption(List<int> imageBytes) async {
    final headers = {
      'Authorization': 'Bearer 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',
    };

    final base64Image = base64Encode(imageBytes);

    final body = {
      'inputs': {
        'image': base64Image,
      }
    };

    final url = Uri.parse(
        'https://api-inference.huggingface.co/models/Salesforce/blip-image-captioning-large');

    final res = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    final status = res.statusCode;
    if (status != 200) {
      throw Exception('http.post error: statusCode= $status');
    }

    final decodedResponse = json.decode(res.body);
    if (decodedResponse is List && decodedResponse.isNotEmpty) {
      final item = decodedResponse[0];
      if (item is Map && item.containsKey('generated_text')) {
        return item['generated_text'];
      }
    }
    throw Exception('Invalid response format');
  }
}
