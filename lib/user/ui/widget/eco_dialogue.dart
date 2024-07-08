


import 'package:adminmuseo/login/ui/widget/eco_button.dart';
import 'package:flutter/material.dart';

class EcoDialogue extends StatelessWidget {
  final String? title;
  const EcoDialogue({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title!),
      actions: [
        EcoButton(
          title: 'Cerrar',
          onPress: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
