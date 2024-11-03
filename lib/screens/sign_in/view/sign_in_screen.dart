import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/common/widgets/exit_confirmation_alert_dialog.dart';
import 'package:task_management/constants/app_colors.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: () {
        return _showExitConfirmationAlertDialog(context);
      },
      child: AppBackground(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 150),
                Text(
                  "Get Started With",
                  style: textTheme.displaySmall,
                ),
                const SizedBox(height: 24),
                _buildSignInForm(context),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      _buildSignUpSection(context),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  RichText _buildSignUpSection(context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.5),
        text: "Don't have an account? ",
        children: [
          TextSpan(
              text: 'Sign Up',
              style: const TextStyle(color: AppColors.colorGreen),
              recognizer: TapGestureRecognizer()..onTap = () {}),
        ],
      ),
    );
  }

  Form _buildSignInForm(context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
              controller: TextEditingController(),
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: "Email"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter email address";
                }
                return null;
              }),
          const SizedBox(height: 20),
          TextFormField(
              controller: TextEditingController(),
              obscureText: true,
              decoration: const InputDecoration(hintText: "Password"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter password";
                }
                return null;
              }),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Icon(
              Icons.arrow_circle_right_outlined,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showExitConfirmationAlertDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => const ExitConfirmationAlertDialog(),
    ).then((value) => value ?? false);
  }
}
