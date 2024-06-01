class GeminiException implements Exception {
  const GeminiException([this.message = 'Unkown problem']);

  final String message;

  @override
  String toString() => 'GeminiException: $message';
}
