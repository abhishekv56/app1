import 'package:assignment2/Models/student_model.dart';
import 'package:assignment2/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:assignment2/Utils/reusable_widgets.dart';

import '../Utils/validators.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});


  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerKey = GlobalKey<FormState>();

  DatabaseHelper dbhelper = DatabaseHelper();

  String? _name;
  String? _email;
  String? _phone;
  String? _password;
  bool isObscure = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Center(
          child: Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Form(
                  key: _registerKey,
                  child: Column(
                    children: [
                      Image.asset('assets/register_img.jpg'),
                      const SizedBox(height: 20,),
                      CustomTextFormWidget(
                          lblText: 'Name',
                          prefixIcon: Icons.person,
                          validator: validateName,
                          keyboardType: TextInputType.text,
                          onSaved: (value) => _name = value
                      ),
                      const SizedBox(height: 10,),
                      CustomTextFormWidget(
                          lblText: 'Email',
                          prefixIcon: Icons.email,
                          validator: validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) => _email = value
                      ),
                      const SizedBox(height: 10,),
                      CustomTextFormWidget(
                          lblText: 'Phone',
                          prefixIcon: Icons.phone,
                          validator: validatePhone,
                          keyboardType: TextInputType.phone,
                          onSaved: (value) => _phone = value
                      ),
                      const SizedBox(height: 10,),
                      CustomTextFormWidget(
                        lblText: 'Password',
                        prefixIcon: Icons.password,
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
                        validator: validatePassword,
                        keyboardType: TextInputType.visiblePassword,
                        onSaved: (value) => _password = value,
                        isObscure: isObscure,
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: TextButton(
                          onPressed: ()  async {
                            if(_registerKey.currentState!.validate()){
                              _registerKey.currentState!.save();

                              Student student = Student(
                                  email: _email!,
                                  name: _name!,
                                  phone:_phone!,
                                  password: _password!
                              );

                              try{
                                await dbhelper.insertStudent(student);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Registration Successful !'))
                                );
                                _registerKey.currentState!.reset();
                              }
                              catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Email/Phone already exists'),
                                      duration: Duration(seconds: 3),
                                  )
                                );
                              }
                            }
                          },
                          child: const Text('REGISTER',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),

                      ),

                    ],
                  ),
                ),
              )
          ),
        )
    );
  }
}
