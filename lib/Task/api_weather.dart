import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static Future getWeatherDataByCity(String city) async {
    String apiKey = '2ZJuVYwG8fOpx7L4tvpjsT';
    String apiSecret = '56lKjEhD3ro1mtKX4GZPia';
    String combinedKey = '$apiKey:$apiSecret';

    return await http.get(
      Uri.parse("https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=$city"),
      headers: {
        HttpHeaders.authorizationHeader: 'apikey $combinedKey',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
  }
}
