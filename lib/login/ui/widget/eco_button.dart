import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EcoButton extends StatelessWidget {
  String? title;
  bool? isLoginButton;
  VoidCallback? onPress;
  bool? isLoading;

  EcoButton(
      {super.key,
      this.title,
      this.isLoginButton = false,
      this.onPress,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 60,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: isLoginButton == false ? Colors.white : Colors.black,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: isLoginButton == false ? Colors.black : Colors.black)),
        child: Stack(
          children: [
            Visibility(
              visible: isLoading!? false:true,
              child: Center(
                  child: Text(
                title ?? "Button",
                style: TextStyle(
                    color:
                    isLoginButton == false ? Colors.black : Colors.white,
                    fontSize: 16),
              )),
            ),
            Visibility(
              visible: isLoading!,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
