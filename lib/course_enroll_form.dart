import 'package:flutter/material.dart';
import 'package:assignment2/Provider/logged_student.dart';
import 'package:assignment2/database_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../Utils/location.dart';

class CourseEnrollForm extends StatefulWidget {
  const CourseEnrollForm({super.key});

  @override
  State<CourseEnrollForm> createState() => _CourseEnrollFormState();
}

class _CourseEnrollFormState extends State<CourseEnrollForm> {
  DatabaseHelper db = DatabaseHelper();
  List<Map<String, dynamic>> courses = [];
  List<int> selectedCourses = [];
  List<int> enrolledCourseList = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final courseList = await db.getCourses();
    setState(() {
      courses = courseList;
    });
  }

  Future<void> _loadEnrolledCourses(int studentId) async {
    try {
      // Get the list of courses the student is already enrolled in
      final enrolledCourses = await db.getEnrolledCourse(studentId);

      // Debugging: Print the enrolled courses to check the response from DB
      print("Enrolled courses from DB: $enrolledCourses");

      // Check if enrolledCourses is not empty and handle null values properly
      if (enrolledCourses.isNotEmpty) {
        setState(() {
          enrolledCourseList = enrolledCourses
              .map<int>((course) {
            // Safely retrieve and cast courseId or handle null
            var courseId = course['cou_id'];
            if (courseId != null && courseId is int) {
              return courseId;
            } else {
              // Log or handle if courseId is null or not an int
              print("Invalid or null courseId: $courseId");
              return 0; // Provide a fallback value
            }
          }).toList();
        });
      }

      // Debugging: Check if enrolledCourseList is being populated correctly
      print("enrolledCourseList: $enrolledCourseList");
    } catch (e) {
      print("Error loading enrolled courses: $e");
    }
  }

  // Load enrolled courses once the student is available
  void _loadStudentEnrolledCourses(LoggedStudent loggedStudent) {
    if (enrolledCourseList.isEmpty) {
      _loadEnrolledCourses(loggedStudent.logStudent!.id!);
    }
  }

  void _onCourseSelected(bool? selected, int courseId) {
    setState(() {
      if (selected == true) {
        selectedCourses.add(courseId);
      } else {
        selectedCourses.remove(courseId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Course Selection")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<LoggedStudent>(
          builder: (context, loggedStudent, child) {
            final studentId = loggedStudent.logStudent!.id!;

            // Load enrolled courses once
            _loadStudentEnrolledCourses(loggedStudent);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: loggedStudent.logStudent!.name,
                  decoration: InputDecoration(labelText: "Student Name"),
                  readOnly: true,
                ),
                SizedBox(height: 20),
                Text(
                  "Available Courses",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];

                      // Ensure both are the same type (int) for proper comparison
                      bool isDisabled = enrolledCourseList.contains(course['id'] as int);

                      return CheckboxListTile(
                        title: Text(course['name']),
                        value: selectedCourses.contains(course['id']),
                        onChanged: isDisabled
                            ? null // Disable the checkbox if already enrolled
                            : (bool? selected) {
                          _onCourseSelected(selected, course['id']);
                        },
                        subtitle: isDisabled
                            ? Text("Already enrolled", style: TextStyle(color: Colors.grey))
                            : null,
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Ensure the user has selected courses
                      if (selectedCourses.isNotEmpty) {
                        Position? position = await determinePosition();
                        String positionString = "${position.latitude},${position.longitude}";

                        for (var courseId in selectedCourses) {
                          await db.insertEnrolledCourse(studentId, courseId, positionString);
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Courses enrolled successfully")),
                        );

                        // Refresh the enrolled courses list after enrollment
                        List<Map<String, dynamic>> updatedCourses = await db.getEnrolledCourse(studentId);

                        // Return the updated courses list back to the Dashboard screen
                        Navigator.pop(context, updatedCourses);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please select at least one course")),
                        );
                      }
                    },
                    child: Text("Enroll"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
