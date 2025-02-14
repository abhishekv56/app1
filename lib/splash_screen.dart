import 'package:assignment2/Register/register_screen.dart';
import 'package:flutter/material.dart';

import 'Login/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/splash_screen_img.png'),
              const SizedBox(height: 30),
              Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(
                  onPressed:(){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>LoginScreen()));
                  },
                  child: const Text('LOGIN',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(
                  onPressed:(){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>RegisterScreen()));
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
      ),
    );
  }
}
