class Course{

  final int id;
  final String name;

  Course({required this.id, required this.name});

  factory Course.fromMap(Map<String,dynamic> map){
    return Course(
        id: map['id'],
        name: map['name']
    );
  }


}

