class SignupRequest {
  final String email;
  final String password;
  final String username;
  final String role;
  final String? track;

  SignupRequest({
    required this.email,
    required this.password,
    required this.username,
    this.role = 'student',
    this.track,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'username': username,
    'role': role,
    if (track != null) 'track': track,
  };
}