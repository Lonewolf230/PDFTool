import 'package:flutter/material.dart';

class MenuButtons extends StatelessWidget {
  const MenuButtons(
      {super.key,
      required this.icon,
      required this.text,
      required this.onPressed});

  final IconData icon;
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      color: Colors.green.shade200,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          onPressed();
        },
        splashColor: Theme.of(context).colorScheme.secondary,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              SizedBox(
                height: 10,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
