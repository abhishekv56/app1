import 'package:assignment2/Provider/logged_student.dart';
import 'package:assignment2/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';


class CourseEnrollForm extends StatefulWidget {
  const CourseEnrollForm({super.key});

  @override
  State<CourseEnrollForm> createState() => _CourseEnrollFormState();
}

class _CourseEnrollFormState extends State<CourseEnrollForm> {

  DatabaseHelper db = DatabaseHelper();
  List<Map<String, dynamic>> courses = [];
  List<int> selectedCourses = [];
  List<int> enrolledCourseList =  [];

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


  void _onCourseSelected(bool? selected, int courseId) {
    setState(() {
      if (selected == true) {
        selectedCourses.add(courseId);
      } else {
        selectedCourses.remove(courseId);
      }
    });
  }
  void _loadEnrolledCourses(int studId) async {
    final enrolledCoursesList = await db.getEnrolledCourse(studId);
    setState(() {
      enrolledCourseList= enrolledCoursesList.map((course) => course['course_id'] as int).toList();
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

                      // Disable the checkbox if the student is already enrolled in the course
                      bool isDisabled = enrolledCourseList.contains(course['id']);
                      return CheckboxListTile(
                        title: Text(course['name']),
                        value: selectedCourses.contains(course['id']),
                        onChanged: isDisabled
                            ? null  // Disable if already enrolled
                            : (bool? selected) {
                          _onCourseSelected(selected, course['id']);
                        },
                        subtitle: isDisabled ? Text("Already enrolled", style: TextStyle(color: Colors.grey)) : null,
                      );
                    },
                  ),
                ),

                SizedBox(height: 20,),
                // Button to save the enrolled courses
                Center(
                  child: ElevatedButton(

                    onPressed: () async {
            // Function to determine position
                    Future<Position> _determinePosition() async {
                    bool serviceEnabled;
                    LocationPermission permission;

                    // Test if location services are enabled
                    serviceEnabled = await Geolocator.isLocationServiceEnabled();
                    if (!serviceEnabled) {
                    return Future.error('Location services are disabled.');
                    }

                    permission = await Geolocator.checkPermission();
                    if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                    if (permission == LocationPermission.denied) {
                    return Future.error('Location permissions are denied');
                    }
                    }

                    if (permission == LocationPermission.deniedForever) {
                    return Future.error(
                    'Location permissions are permanently denied, we cannot request permissions.');
                    }

                    // When permissions are granted, get the current position
                    return await Geolocator.getCurrentPosition();
                    }

                    // Get position
                    Position? position = await _determinePosition();

                    // Convert position to a string (latitude,longitude)
                    String positionString = "${position.latitude},${position.longitude}";

                    // Debugging: Print selected courses and position
                    print(selectedCourses);
                    print(positionString);

                    final studentId = loggedStudent.logStudent!.id;
                    print(studentId);
                    // Save each selected course into the enrolled courses table, along with the position
                    for (var courseId in selectedCourses) {
                    await db.insertEnrolledCourse(studentId!, courseId, positionString);
                    }
                    // Show a confirmation or success message
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Courses enrolled successfully")),
                    );
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

