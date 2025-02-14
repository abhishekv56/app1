import 'package:assignment2/Provider/logged_student.dart';
import 'package:assignment2/Utils/reusable_widgets.dart';
import 'package:assignment2/Utils/validators.dart';
import 'package:assignment2/course_enroll_form.dart';
import 'package:assignment2/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/student_model.dart';

class Dashboard extends StatefulWidget {

  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


  @override
  Widget build(BuildContext context) {
    return Consumer<LoggedStudent>(
      builder: (context, loggedStudent, child){
          return Scaffold(
            drawer: Drawer(
                child: Center(
                    child: Text('Welcome, ${loggedStudent.logStudent!.name}')
                )

            ),
            appBar: AppBar(
              title:Text('The Courses Enrolled'),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>CourseEnrollForm()));
              },

            ),
          );
      },
    );

  }
}
