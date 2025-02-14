class EnrolledCourse{
  int? enrollId;
  final int studentId;
  final int courseId;
  final String location;

  EnrolledCourse({required this.studentId,required this.courseId, required this.location});

  Map<String, dynamic> toMap(){
    return {
      'stud_id': studentId,
      'cou_id': courseId,
      'location':location,
    };
  }

}