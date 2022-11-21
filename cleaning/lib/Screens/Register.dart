import 'dart:math';
import 'package:cleaning/Screens/Login.dart';
import 'package:cleaning/Services/UserService.dart';
import 'package:cleaning/Widgets/RandomCircle.dart';
import 'package:cleaning/Widgets/button.dart';
import 'package:cleaning/Widgets/text_input.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: [
            Positioned(
              left: width / 10,
              child: Container(
                height: 150,
                width: width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(250.0),
                        bottomRight: Radius.circular(10.0)),
                    gradient: LinearGradient(
                        colors: [Colors.black, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
              ),
            ),
            Positioned(
              top: height / 10,
              left: width / 3,
              child: Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            for(int i = 1; i < 20 + Random().nextInt(10) + 1; i++)
            RandomCircle(),
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 130.0),
                    child: Center(
                      child: Column(
                        children: [
                          TextInput(
                            controller: _usernameController,
                            hideText: false,
                            hintText: 'Name',
                            iconData: Icons.person,
                            inputAction: TextInputAction.next,
                          ),
                          TextInput(
                            controller: _phoneNumberController,
                            hideText: false,
                            hintText: 'Phone',
                            iconData: Icons.phone_android,
                            inputAction: TextInputAction.next,
                          ),
                          TextInput(
                            controller: _addressController,
                            hideText: false,
                            hintText: 'Address',
                            iconData: Icons.location_city,
                            inputAction: TextInputAction.next,
                          ),
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
                              buttonText: "Register",
                              onPress: () async{
                                UserService()
                                .register(_usernameController.text, 
                                    _phoneNumberController.text, 
                                    _addressController.text, 
                                    _emailController.text, 
                                    _passwordController.text);
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: height - height / 6, right: width / 1.75),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(250.0)),
                    gradient: LinearGradient(
                        colors: [Colors.black, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
