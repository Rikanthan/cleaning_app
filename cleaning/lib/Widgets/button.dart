import 'package:flutter/material.dart';
class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.buttonText,
    required this.onPress
  });
  final String buttonText;
  final Function() onPress;
  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                  child:Container(
                    height: 50,
                    width: 150,
                        decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 0.7, 
                                                style: BorderStyle.solid
                                                ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25),
                                                  ),
                                                
                          gradient: LinearGradient(
                        colors: [Colors.blue,Colors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight
                          )
                        ),
                    child: TextButton(
                     child: Text(
                        buttonText,
                        style:TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lato',
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      onPressed: onPress,
                     style:ButtonStyle(
                        backgroundColor: MaterialStateColor
                                                        .resolveWith(
                                                                  (states) => Colors.transparent 
                                                                    ),
                        padding:  MaterialStateProperty
                                                      .resolveWith(
                                                                  (states) => EdgeInsets.only(
                                                                                        left:36,
                                                                                        right:36,
                                                                                        )
                                                                                    ),
                        shape: MaterialStateProperty
                                              .all(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10)
                                                  ),
                      ),                
                    )
              ),
          )
        )
    );
  }
}