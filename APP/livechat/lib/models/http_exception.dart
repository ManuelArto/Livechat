class HttpException implements Exception {
  final String message;
  final int statusCode;

  HttpException(this.message, this.statusCode);

  @override
  String toString() {
    return message;
  }
}
