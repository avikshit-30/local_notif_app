import 'package:http/http.dart' as http;

class HttpClientSingleton {
  
  static http.Client? _httpClient;

  static http.Client get instance {
    _httpClient ??= http.Client();

    return _httpClient!;
  }
}