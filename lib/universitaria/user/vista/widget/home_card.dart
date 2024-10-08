
import 'package:adminmuseo/universitaria/utils/styles.dart';
import 'package:flutter/material.dart';

class HomeCards extends StatelessWidget {
  final String? title;
  const HomeCards({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent.withOpacity(0.8),
                Colors.redAccent.withOpacity(0.8),
              ],
            )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title??"TITLE",
              style: EcoStyle.boldStyle.copyWith(color: Colors.white)),
        ),
      ),
    );
  }
}
