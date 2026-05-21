import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_client.dart';

/// Provider for [DioClient] — single instance across the app.
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});
