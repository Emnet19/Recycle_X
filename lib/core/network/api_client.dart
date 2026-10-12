import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_endpoints.dart';

/// Thin HTTP client wrapper.
/// All feature services call this instead of using [http] directly,
/// so auth headers and base URL are handled in one place.
class ApiClient {
  ApiClient._();

  static String? _authToken;

  static void setToken(String token) => _authToken = token;
  static void clearToken() => _authToken = null;

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  // ─── GET ──────────────────────────────────────────────────────────────────
  static Future<dynamic> get(String url) async {
    final response =
        await http.get(Uri.parse(url), headers: _headers);
    return _handleResponse(response);
  }

  // ─── POST ─────────────────────────────────────────────────────────────────
  static Future<dynamic> post(String url, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(url),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  // ─── PUT ──────────────────────────────────────────────────────────────────
  static Future<dynamic> put(String url, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse(url),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  // ─── DELETE ───────────────────────────────────────────────────────────────
  static Future<dynamic> delete(String url) async {
    final response =
        await http.delete(Uri.parse(url), headers: _headers);
    return _handleResponse(response);
  }

  // ─── PATCH ────────────────────────────────────────────────────────────────
  static Future<dynamic> patch(String url, Map<String, dynamic> body) async {
    final response = await http.patch(
      Uri.parse(url),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  // ─── Response handler ─────────────────────────────────────────────────────
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      final body = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : {'message': 'Unknown error'};
      throw ApiException(
        statusCode: response.statusCode,
        message: body['message'] ?? 'Request failed',
      );
    }
  }

  /// Convenience: build full endpoint from [ApiEndpoints] constants.
  static String endpoint(String path) => path;
}

/// Thrown when the server returns a non-2xx status.
class ApiException implements Exception {
  final int statusCode;
  final String message;
  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
