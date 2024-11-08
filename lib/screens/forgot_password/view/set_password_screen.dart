import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/api_path.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/constants/app_strings.dart';
import 'package:task_management/network/network_response.dart';
import 'package:task_management/network/network_service.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key, required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isSetPassword = false;
  bool isProgress = false;

  Future<void> setPassword() async {
    if (formKey.currentState!.validate()) {
      setState(() => isProgress = true);

      final password = _passwordController.text;
      final Map<String, String> requestBody = {
        "email": widget.email,
        "OTP": widget.otp,
        "password": password
      };

      final NetworkResponse response = await NetworkService.postRequest(
        context: context,
        url: ApiPath.setPassword,
        requestBody: requestBody,
      );

      setState(() => isProgress = false);
      if (response.isSuccess) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.signIn,
          (route) => false,
        );
        Fluttertoast.showToast(
          msg: response.requestResponse["data"],
          backgroundColor: AppColors.colorGreen,
        );
      } else {
        Fluttertoast.showToast(
          msg: response.errorMessage,
          backgroundColor: AppColors.colorRed,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return AppBackground(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 150),
                Text("Set Password", style: textTheme.displaySmall),
                const SizedBox(height: 20),
                Text(
                  "Minimum length password 8 characters with letters and numbers",
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: 24),
                _buildPasswordAndConfirmPasswordForm(),
                const SizedBox(height: 40),
                Center(child: _buildSignInSection()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _buildPasswordAndConfirmPasswordForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: "Password"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a password";
              } else if (!RegExp(RegularExpression.password).hasMatch(value)) {
                return "At least 8 characters and both letters and numbers";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: "Confirm Password"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please confirm your password";
              } else if (value != _passwordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: setPassword,
            child: isProgress
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                        CircularProgressIndicator(color: AppColors.colorWhite),
                  )
                : const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  RichText _buildSignInSection() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
        text: "Have an account? ",
        children: [
          TextSpan(
            text: 'Sign In',
            style: const TextStyle(color: AppColors.colorGreen),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.signIn,
                    (route) => false,
                  ),
          ),
        ],
      ),
    );
  }
}
