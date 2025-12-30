import 'package:flutter/material.dart';

class LetterHeadWidget extends StatelessWidget {
  const LetterHeadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFFEFF4F8),
            child: Icon(
              Icons.store,
              color: Colors.green.shade600,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 12),

        Center(
          child: Column(
            children: [
              Text(
                'Leysco Mini Sales',
                style: TextTheme.of(context).bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Tom Mboya St, Nairobi, Nairobi',
                style: TextTheme.of(context).labelMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
