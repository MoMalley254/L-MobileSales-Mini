import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/auth_provider.dart';

class ResetPasswordWidget extends ConsumerStatefulWidget {
  final ValueChanged<bool> updateActiveWidget;
  const ResetPasswordWidget({
    super.key,
    required this.updateActiveWidget
  });

  @override
  ConsumerState<ResetPasswordWidget> createState() => _ResetPasswordWidgetState();
}

class _ResetPasswordWidgetState extends ConsumerState<ResetPasswordWidget> {
  final GlobalKey<FormState> _resetFormKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void showSignIn() {
    widget.updateActiveWidget(true);
  }

  void doReset() {
    if (_resetFormKey.currentState!.validate()) {
      print('Do password reset');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildPasswordReset(context);
  }

  Widget buildPasswordReset(BuildContext context) {
    final authNotifier = ref.read(authProviderNotifier.notifier);

    return Form(
      key: _resetFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Container(
        height: MediaQuery.of(context).size.height * .6,
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildUsernameSect(context, authNotifier),
            const SizedBox(height: 15),
            buildEmailSect(context, authNotifier),
            const SizedBox(height: 15,),
            buildExtraButtons(context),
            const SizedBox(height: 15,),
            buildResetPasswordButton(context),
            const SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }

  Widget buildUsernameSect(BuildContext context, AuthNotifier authNotifier) {
    return buildFormField(
        context,
        'Username',
        'Enter your username',
        _usernameController,
        true,
        authNotifier
    );
  }

  Widget buildEmailSect(BuildContext context, AuthNotifier authNotifier) {
    return buildFormField(
        context,
        'Email',
        'Enter your email',
        _emailController,
        false,
        authNotifier
    );
  }

  Widget buildFormField(
      BuildContext context,
      String label,
      String hint,
      TextEditingController controller,
      bool isUsername,
      AuthNotifier authNotifier
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextTheme.of(context).labelLarge),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            keyboardType:
            isUsername ? TextInputType.text : TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return isUsername
                    ? 'Username is required'
                    : 'Email is required';
              }

              if (!isUsername) {
                final emailRegex =
                RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(value)) {
                  return 'Enter a valid email address';
                }
              }

              return null;
            },
            onChanged: (value) {
              if(isUsername) {
                authNotifier.updateUsername(value);
              } else {
                authNotifier.updateEmail(value);
              }
            },
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: IconButton(
                  onPressed: null,
                  icon: Icon(isUsername ? Icons.person : Icons.email)
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(14),
              ),
              filled: true,
              fillColor: Colors.grey[400],
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExtraButtons(BuildContext context) {
    return TextButton(
        onPressed: showSignIn,
        child: Text(
          'Return to login screen',
            style: TextTheme.of(context).bodyMedium?.copyWith(
                color: Colors.green
            )
        )
    );
  }

  Widget buildResetPasswordButton(BuildContext context) {
    final bool hasEverything = ref.watch(authProviderNotifier).validForPasswordReset;

    return InkWell(
      onTap: () {
        if (hasEverything) {
          doReset();
        }
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: hasEverything ? Colors.blueAccent : Colors.grey[400],
            borderRadius: BorderRadius.circular(30)
        ),
        child: Text(
          'Send Reset Link',
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
