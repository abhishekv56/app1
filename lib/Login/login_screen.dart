
import 'package:assignment2/Models/student_model.dart';
import 'package:assignment2/Provider/logged_student.dart';
import 'package:assignment2/Register/register_screen.dart';
import 'package:assignment2/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }

}

class _LoginScreenState extends State<LoginScreen> {
  final _loginKey = GlobalKey<FormState>();

  DatabaseHelper db= DatabaseHelper();

  final username = TextEditingController();
  final password = TextEditingController();

  var isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        child: SingleChildScrollView(
          child: Form(
            key: _loginKey,
            child: Column(
              children: [
                Image.asset('assets/LoginPageImg.jfif'),
                const SizedBox(height: 30),
                TextFormField(
                  controller: username,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    labelText: 'Enter email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: password,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Enter password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: isObscure
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextButton(
                    onPressed: () async {
                      if(_loginKey.currentState!.validate()){
                        Student stud = Student(
                          email: username.text,
                          password: password.text,
                        );

                        var isValid = await db.autheticateStudent(stud);
                        if(isValid){
                          final stud=Student(email: username.text);
                          Student loggedStudent = await db.getLoggedStudent(stud);
                          LoggedStudent logStud = Provider.of<LoggedStudent>(context , listen: false);
                          logStud.setStudent(loggedStudent);

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Dashboard()));
                        }
                        else
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Invalid Credentials/User not found'))
                          );
                        }
                      }

                    },

                    child: const Text('LOGIN',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),

                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Dont have an account?'),
                    TextButton(onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> RegisterScreen()));
                    },
                        child: const Text('SIGN UP',
                          style: TextStyle(
                              color: Colors.deepPurple
                          ),
                        )
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}




