import 'package:assignment2/Models/student_model.dart';
import 'package:flutter/material.dart';

class LoggedStudent extends ChangeNotifier{

 Student? loggedStudent;

 Student? get logStudent => loggedStudent;

 void setStudent(Student student){
   loggedStudent = student;
   notifyListeners();
 }
}