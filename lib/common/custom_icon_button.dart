import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {

  const CustomIconButton({required this.iconData, required this.color, required this.onTap, required this.size});

  final IconData iconData;
  final Color color;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(
              iconData,
              color: color,
              size: size,
            ),
          ),
        ),
      ),
    );
  }
}
