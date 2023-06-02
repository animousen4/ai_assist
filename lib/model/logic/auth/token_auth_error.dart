class TokenAuthError implements Exception {
  final String? token;
  final int code;

  TokenAuthError(this.token, this.code);

  bool get isPermanent => code == 401;
  bool get isTemporary => code == 429;
}
