import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput({
   required this.hideText,
   required this.hintText,
   required this.iconData,
   required this.inputAction,
   required this.controller
  });
  final IconData iconData;
  final bool hideText;
  final String hintText;
  final TextInputAction inputAction;
  final TextEditingController controller;

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool isHide = true;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.only(top:30),
      child: Container(
        color: Colors.white,
        height: 56,
        width: 300,
        child: TextFormField(
                        controller: widget.controller,
                        textInputAction: widget.inputAction,
                        obscureText: widget.hideText && isHide ,
                        decoration: InputDecoration(
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          widget.iconData,
                          color: Colors.black,
                          size: 20,
                          ),
                          suffix: IconButton(
                            onPressed: (){
                              setState(() {
                               isHide = !isHide;
                              });
                            },
                            icon: Icon(
                              widget.hideText && isHide ? Icons.visibility : Icons.visibility_off,
                              color: widget.hideText ? Colors.black: Colors.white ,
                              ),
                          ),
                          labelStyle:  TextStyle(
                                  fontFamily: 'Lato',
                                  color: Colors.black,
                                  fontSize: 18
                                  ),
                        filled: true,
                         hintText:widget.hintText,
                            hintStyle: TextStyle(
                                  fontFamily: 'Lato',
                                  color: Colors.black,
                                  fontSize: 18
                                  ),
                        enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                      focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Color(0xFF858585),
                        width: 2.0,
                      ),
                    ),
                  ),
                   style: TextStyle(color: Colors.white),
                ),
      ),
    );
  }
}