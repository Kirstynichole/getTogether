import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function(String)? onTap;

  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? () => onTap!(text) : null,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(193, 109, 186, 1),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(
              Icons.person,
              color: Color.fromRGBO(41, 23, 61, 1),),
            const SizedBox(width: 20),
            Text(
              text,
              style: const TextStyle(
                color: Color.fromRGBO(41, 23, 61, 1),)
                ),
          ],
        ),
      ),
    );
  }
}
