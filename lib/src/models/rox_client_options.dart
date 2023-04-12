class RoxClientOptions {
  RoxClientOptions({
    this.sendTimeout,
    this.receiveTimeout,
    this.headers,
  })  : assert(receiveTimeout == null || !receiveTimeout.isNegative),
        assert(sendTimeout == null || !sendTimeout.isNegative);

  final Duration? receiveTimeout;
  final Duration? sendTimeout;
  final Map<String, String>? headers;
}
