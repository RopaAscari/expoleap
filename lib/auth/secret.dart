class Secret {
  final String token;
  final String event;
  final String baseUrl;
  final int timeout;

  Secret(
      {required this.token,
      required this.event,
      required this.baseUrl,
      required this.timeout});

  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return new Secret(
        token: jsonMap['token'],
        event: jsonMap['event'],
        baseUrl: jsonMap['baseUrl'],
        timeout: jsonMap['timeout']);
  }
}
