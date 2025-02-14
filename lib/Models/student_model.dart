class Student {
  final int? id;
  final String? name;
  final String email;
  final String? phone;
  final String? password;

  Student({
    this.id,
    this.name,
    required this.email,
    this.phone,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
    );
  }
}