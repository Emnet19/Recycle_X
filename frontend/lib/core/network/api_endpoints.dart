/// Base URL for the RecycleX Node.js / Express backend.
/// Change [baseUrl] to point to your deployed server when ready.
class ApiEndpoints {
  ApiEndpoints._();

  // ─── Base ─────────────────────────────────────────────────────────────────
  static const String baseUrl = 'http://localhost:3000/api/v1';

  // ─── Auth ─────────────────────────────────────────────────────────────────
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String googleAuth = '$baseUrl/auth/google';
  static const String logout = '$baseUrl/auth/logout';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String verifyEmail = '$baseUrl/auth/verify-email';
  static const String me = '$baseUrl/auth/me';

  // ─── Users ────────────────────────────────────────────────────────────────
  static const String users = '$baseUrl/users';
  static String userById(String id) => '$baseUrl/users/$id';

  // ─── Customer ─────────────────────────────────────────────────────────────
  static const String customerProfile = '$baseUrl/customers/me';
  static const String collectionHistory = '$baseUrl/customers/me/history';

  // ─── Collector ────────────────────────────────────────────────────────────
  static const String collectorProfile = '$baseUrl/collectors/me';
  static const String collectorRequests = '$baseUrl/collectors/me/requests';
  static const String collectorEarnings = '$baseUrl/collectors/me/earnings';
  static String collectorAvailability(String id) =>
      '$baseUrl/collectors/$id/availability';

  // ─── Company ──────────────────────────────────────────────────────────────
  static const String companyProfile = '$baseUrl/companies/me';
  static const String companyMaterials = '$baseUrl/companies/me/materials';

  // ─── Collection Requests ──────────────────────────────────────────────────
  static const String collectionRequests = '$baseUrl/collections';
  static String collectionRequestById(String id) =>
      '$baseUrl/collections/$id';
  static const String emergencyPickup = '$baseUrl/collections/emergency';

  // ─── Wallet / Transactions ────────────────────────────────────────────────
  static const String wallet = '$baseUrl/wallet';
  static const String transactions = '$baseUrl/wallet/transactions';

  // ─── Notifications ────────────────────────────────────────────────────────
  static const String notifications = '$baseUrl/notifications';

  // ─── Reviews ──────────────────────────────────────────────────────────────
  static const String reviews = '$baseUrl/reviews';
  static String reviewsByCollector(String id) =>
      '$baseUrl/reviews/collector/$id';
}
