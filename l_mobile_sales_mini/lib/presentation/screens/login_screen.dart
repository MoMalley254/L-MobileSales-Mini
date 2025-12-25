import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/presentation/controllers/auth_provider.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/auth/password_validate_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/auth/reset_password_widget.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/auth/sign_in_widget.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool showSignIn = true;

  void updateActiveWidget(bool shouldShowSignIn) {
    setState(() {
      showSignIn = shouldShowSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black12),
      body: buildLoginBody(context),
      backgroundColor: Colors.white,
    );
  }

  Widget buildLoginBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black12),
      child: Column(
        children: [
          buildLogo(context),
          const SizedBox(height: 10),
          showSignIn ? SignInWidget(updateActiveWidget: updateActiveWidget) : ResetPasswordWidget(updateActiveWidget: updateActiveWidget),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildLogo(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .2,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[300],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Spacer(),
          buildLogoTop(context),
          const SizedBox(height: 10),
          showSignIn ? buildWelcomeText(context) : buildResetHeader(context),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildLogoTop(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.store, size: 60),
        Text(
          'Leysco Mobile Sales',
          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildWelcomeText(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Welcome Back, ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: 'please login to proceed',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget buildResetHeader(BuildContext context) {
    return Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Reset Password \n ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: 'Enter your username and registered email address to receive password reset instructions',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        )
    );
  }
}
