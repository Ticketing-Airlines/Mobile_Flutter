class User {
  final String fullName;
  final String email;
  final String address;
  final String age;
  final String gender;
  final String birthdate;
  final String contactNumber;

  User({
    required this.fullName,
    required this.email,
    required this.address,
    required this.age,
    required this.gender,
    required this.birthdate,
    required this.contactNumber,
  });
}

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final List<User> _users = [];

  List<User> get users => List.unmodifiable(_users);

  void addUser(User user) {
    _users.add(user);
  }

  void removeUser(String email) {
    _users.removeWhere((user) => user.email == email);
  }
}
