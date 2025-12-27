import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l_mobile_sales_mini/core/navigation/route_names.dart';
import 'package:l_mobile_sales_mini/presentation/widgets/specific/auth/password_validate_widget.dart';

import '../../../../data/models/auth_model.dart';
import '../../../controllers/auth_provider.dart';

class SignInWidget extends ConsumerStatefulWidget {
  final ValueChanged<bool> updateActiveWidget;
  const SignInWidget({
    super.key,
    required this.updateActiveWidget
  });

  @override
  ConsumerState<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends ConsumerState<SignInWidget> {
  bool isLoading = false;

  bool hidePassword = true;
  bool rememberMe = false;
  final GlobalKey<FormState> _signInFormKey = GlobalKey();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void togglePasswordVisibility() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  void toggleRememberMe() {
    setState(() {
      rememberMe = !rememberMe;
    });
  }

  void showPasswordReset() {
    widget.updateActiveWidget(false);
  }

  Future<void> doLogin() async{
    setState(() {
      isLoading = true;
    });

    if(_signInFormKey.currentState!.validate()) {
      final authProvider = ref.read(authProviderNotifier.notifier);
      await authProvider.login(_usernameController.text, _passwordController.text, rememberMe);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AuthModel>>(authProviderNotifier, (previous, next) {
      next.when(
        data: (user) {
          final authState = ref.read(authProviderNotifier).value?.isAuthenticated ?? false;
          if (authState) {
            if (context.mounted) {
              context.go(RouteNames.dashboardRoute);
            }
          }
        },
        error: (error, stack) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
        loading: () {},
      );
    });

    return buildFormSection(context);
  }

  Widget buildFormSection(BuildContext context) {
    final authNotifier = ref.read(authProviderNotifier.notifier);
    return Form(
      key: _signInFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Container(
        height: MediaQuery.of(context).size.height * .6,
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign In',
                style: TextTheme.of(context).bodyLarge
              ),
              buildUsernameSect(context, authNotifier),
              const SizedBox(height: 15),
              buildPasswordSect(context, authNotifier),
              const SizedBox(height: 10,),
              buildPasswordValidation(context),
              const SizedBox(height: 15,),
              buildExtraButtons(context),
              const SizedBox(height: 15,),
              buildLoginButton(context),
              const SizedBox(height: 15,),
            ],
          ),
        )
      ),
    );
  }

  Widget buildUsernameSect(BuildContext context, AuthNotifier authNotifier) {
    return buildFormField(
        context,
        'Username',
        'Enter your username',
        _usernameController,
        false,
        authNotifier
    );
  }

  Widget buildPasswordSect(BuildContext context, AuthNotifier authNotifier) {

    return buildFormField(
        context,
        'Password',
        '**********',
        _passwordController,
        true,
        authNotifier
    );
  }

  Widget buildFormField(
      BuildContext context,
      String label,
      String hint,
      TextEditingController controller,
      bool isPassword,
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
            obscureText: isPassword ? hidePassword : false,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return isPassword
                    ? 'Password is required'
                    : 'username is required';
              }
              return null;
            },
            onChanged: (value) {
              if(isPassword) {
                ref.read(authProviderNotifier.notifier).validatePassword(value);
              } else {
                ref.read(authProviderNotifier.notifier).updateUsername(value);
              }
            },
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: IconButton(
                  onPressed: isPassword ? togglePasswordVisibility : null,
                  icon: Icon(isPassword ? hidePassword ? Icons.visibility : Icons.visibility_off : Icons.person)
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

  Widget buildPasswordValidation(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * .2,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: PasswordValidateWidget()
    );
  }

  Widget buildExtraButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: toggleRememberMe,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  rememberMe ? Icons.check_box : Icons.check_box_outline_blank_sharp,
                  size: 20,
                ),
                const SizedBox(width: 10,),
                Text(
                    'Remember Me',
                    style: TextTheme.of(context).bodyMedium
                )
              ],
            ),
          ),
        ),
        TextButton(
            onPressed: showPasswordReset,
            child: Text(
              'Forgot Password?',
              style: TextTheme.of(context).bodyMedium?.copyWith(
                color: Colors.green
              )
            )
        )
      ],
    );
  }

  Widget buildLoginButton(BuildContext context) {
    final bool hasEverything = ref.watch(authProviderNotifier).value?.allInputsProvided ?? false;

    return InkWell(
      onTap: () {
        if (hasEverything) {
          doLogin();
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
        child: isLoading ? const Center(
          child: CircularProgressIndicator(color: Colors.green),
        ) : Text(
          'Log In',
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
