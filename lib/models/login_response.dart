class AccessResponse {
  final String? token;
  final String? username;
  final String? role;
  final String? message;
  final Map<String, dynamic>? userData;

  AccessResponse({
    this.token,
    this.username,
    this.role,
    this.message,
    this.userData,
  });

  factory AccessResponse.fromJson(Map<String, dynamic> json) {
    return AccessResponse(
      token: json['token'],
      username:
          json['record']?['name'] ??
          json['record']?['username'] ??
          json['username'],
      role: json['record']?['role'] ?? 'student', // Extract role from record
      message: json['message'],
      userData: json['record']?.cast<String, dynamic>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'username': username,
      'role': role,
      'message': message,
      'userData': userData,
    };
  }

  bool get isValid => token != null && token!.isNotEmpty;
}
