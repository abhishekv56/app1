import 'package:assignment2/Provider/logged_student.dart';
import 'package:assignment2/Utils/reusable_widgets.dart';
import 'package:assignment2/Utils/validators.dart';
import 'package:assignment2/course_enroll_form.dart';
import 'package:assignment2/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Login/login_screen.dart';
import '../Models/student_model.dart';

class Dashboard extends StatefulWidget {

  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<Map<String,dynamic>> enrolledList=[];


  DatabaseHelper db= DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoggedStudent>(
      builder: (context, loggedStudent, child){
        int? curLoggedStudentId= loggedStudent.logStudent!.id;
          return Scaffold(
            drawer: Drawer(
                child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                              const CircleAvatar(
                                radius: 80,
                                backgroundImage: AssetImage('assets/profile.webp'),
                              ),
                              SizedBox(height: 20,),
                              Text(
                                '${loggedStudent.logStudent!.name}',
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                '${loggedStudent.logStudent!.email}',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey
                                ),
                              ),
                              SizedBox(height: 30,),
                              Container(
                                height: 55,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                                  },
                                  child: const Text('LOG OUT',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              ListTile(
                                leading: Icon(Icons.person,  size: 30,),
                                title: Text('${loggedStudent.logStudent!.name}'),
                                subtitle: Text('Name'),
                              ),
                              ListTile(
                                leading: Icon(Icons.email,  size: 30,),
                                title: Text('${loggedStudent.logStudent!.email}'),
                                subtitle: Text('Email'),
                              ),
                              ListTile(
                                leading: Icon(Icons.phone,  size: 30,),
                                title: Text('${loggedStudent.logStudent!.phone}'),
                                subtitle: Text('Contact'),
                              )

                        ],
                      ),
                    )
                )
                ),

            appBar: AppBar(
              title:Text('The Courses Enrolled'),
            ),
            body: FutureBuilder(
                future: db.getEnrolledCourse(curLoggedStudentId!),  // Fetch enrolled courses
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No courses enrolled.'));
                  }
                  enrolledList = snapshot.data!;

                  return ListView.builder(
                    itemCount: enrolledList.length,
                    itemBuilder: (context, index) {
                      var course = enrolledList[index];
                      // Use null-aware operator (??) to provide a fallback value in case of null
                      String courseName = course['name'] ?? 'No Name';  // Default to 'No Name' if 'name' is null
                      String courseLocation = course['location'] ?? 'Unknown Location';  // Default to 'Unknown Location' if 'location' is null

                      return ListTile(
                        title: Text(courseName),  // Use the course name, with a fallback for null
                        subtitle: Text('Enrolled in $courseLocation'),  // Use the course location, with a fallback for null
                      );
                    },
                  );
                }
            ),

            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                // Navigate to CourseEnrollForm and await the updated courses list
                List<Map<String, dynamic>> updatedCourses = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CourseEnrollForm()),
                );

                // After returning from CourseEnrollForm, update the enrolled courses list
                if (updatedCourses != null) {
                  setState(() {
                    enrolledList = updatedCourses;
                  });
                }
              },
            ),

          );
      },
    );

  }
}
