import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/presentation/controllers/auth_provider.dart';

class PasswordValidateWidget extends ConsumerWidget {
  const PasswordValidateWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordProvider = ref.watch(authProviderNotifier);
    return Wrap(
      runSpacing: 20.0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildRequirement(
            passwordProvider.hasMinLength,
            '8+ Characters'
        ),
        _buildRequirement(
            passwordProvider.hasUppercaseLetter,
            '1 Uppercase letter'
        ),
        _buildRequirement(
            passwordProvider.hasANumber,
            '1 Number'
        ),
        _buildRequirement(
            passwordProvider.hasASpecialCharacter,
            '1 Special Character'
        ),
      ],
    );
  }

  Widget _buildRequirement(bool condition, String text) {
    return Row(
      children: [
        Icon(
          condition ? Icons.check_circle : Icons.circle_outlined,
          color: condition ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 20,),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        )
      ],
    );
  }
}
