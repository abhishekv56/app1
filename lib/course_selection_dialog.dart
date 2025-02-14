import 'package:flutter/material.dart';

import 'Models/courses.dart';

class CourseSelectionDialog extends StatefulWidget {


  CourseSelectionDialog({super.key});

  @override
  _CourseSelectionDialogState createState() => _CourseSelectionDialogState();
}

class _CourseSelectionDialogState extends State<CourseSelectionDialog> {


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Courses'),
      content: SingleChildScrollView(
        child: Column(
          children: [

          ]
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {

          },
          child: Text('Done'),
        ),
      ],
    );
  }
}