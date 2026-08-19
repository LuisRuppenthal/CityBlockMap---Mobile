enum UserRole { admin, user }

extension UserRoleValue on UserRole {
  String get value => this == UserRole.admin ? 'ADMIN' : 'USER';
  String get label => this == UserRole.admin ? 'Administrador' : 'Usuário';

  static UserRole fromValue(String value) {
    return value == 'ADMIN' ? UserRole.admin : UserRole.user;
  }
}

class User {
  final int id;
  final String login;
  final UserRole role;

  User({required this.id, required this.login, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      login: json['login'],
      role: UserRoleValue.fromValue(json['role']),
    );
  }
}

class UserRequest {
  final String login;
  final String password;
  final UserRole role;

  UserRequest({
    required this.login,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
    'role': role.value,
  };
}
