import 'dart:math';

import 'package:cleaning/Screens/ImageUpload.dart';
import 'package:cleaning/Screens/Register.dart';
import 'package:cleaning/Services/UserService.dart';
import 'package:cleaning/Widgets/button.dart';
import 'package:cleaning/Widgets/text_input.dart';
import 'package:flutter/material.dart';

import '../Widgets/RandomCircle.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              child: Container(
                height: height/3,
                width: width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(height/2),
                        bottomRight: Radius.circular(10.0)),
                    gradient: LinearGradient(
                        colors: [Colors.black, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            for (int i = 1; i < 20 + Random().nextInt(10) + 1; i++)
              RandomCircle(),
            Padding(
              padding: EdgeInsets.only(top: 260.0),
              child: Center(
                child: Column(
                  children: [
                    TextInput(
                      controller: _emailController,
                      hideText: false,
                      hintText: 'Email',
                      iconData: Icons.email_sharp,
                      inputAction: TextInputAction.next,
                    ),
                    TextInput(
                      controller: _passwordController,
                      hideText: true,
                      hintText: 'Password',
                      iconData: Icons.lock,
                      inputAction: TextInputAction.go,
                    ),
                    CustomButton(
                        buttonText: "Log in",
                        onPress: () async{
                          UserService().login(_emailController.text, _passwordController.text);
                        }),
                    TextButton(
                        onPressed: () {}, child: Text('Forgot your password?')),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Register()));
                      },
                      child: Text("Don't have an account? Register now!"),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height - 100, right: width / 1.5),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(200.0)),
                  gradient: LinearGradient(
                      colors: [Colors.black, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
                clipBehavior: Clip.antiAlias,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
