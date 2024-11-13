import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_management/common/auth_controller.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/common/widgets/exit_confirmation_alert_dialog.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/api_path.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/constants/app_strings.dart';
import 'package:task_management/network/network_response.dart';
import 'package:task_management/network/network_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthController _authController = AuthController();
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isSignIn = false;
  bool isProgress = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      isSignIn = formKey.currentState?.validate() ?? false;
    });
  }

  void disposeTextFields() {
    _emailController.dispose();
    _passwordController.dispose();
  }

  void clearTextFields() {
    _emailController.clear();
    _passwordController.clear();
  }

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
                        onPressed: () =>
                            Navigator.pushNamed(context, Routes.emailAddress),
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
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.pushNamed(context, Routes.signUp)),
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: "Email"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter email address";
                } else if (!RegExp(RegularExpression.email).hasMatch(value)) {
                  return "Invalid email format";
                }
                return null;
              }),
          const SizedBox(height: 20),
          TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: "Password"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter password";
                } else if (!RegExp(RegularExpression.password)
                    .hasMatch(value)) {
                  return "At least 8 characters and both letters and numbers";
                }
                return null;
              }),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isSignIn ? signIn : null,
            child: isProgress
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.colorWhite,
                    ),
                  )
                : const Icon(
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

  Future<void> signIn() async {
    if (formKey.currentState!.validate()) {
      isProgress = true;
      setState(() {});
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final Map<String, String> requestBody = {
        "email": email,
        "password": password
      };

      final NetworkResponse response = await NetworkService.postRequest(
          context: context, url: ApiPath.login, requestBody: requestBody);
      isProgress = false;
      setState(() {});
      if (response.isSuccess) {
        await _authController
            .saveAccessToken(response.requestResponse["token"]);
        await _authController.saveUserInfo(
            response.requestResponse["data"]["email"],
            response.requestResponse["data"]["firstName"],
            response.requestResponse["data"]["lastName"],
            response.requestResponse["data"]["mobile"],
            response.requestResponse["data"]["photo"]);
        Navigator.pushNamed(context, Routes.home);
        clearTextFields();
        Fluttertoast.showToast(
            msg: "Login Complete", backgroundColor: AppColors.colorGreen);
      } else {
        Fluttertoast.showToast(
            msg: response.errorMessage, backgroundColor: AppColors.colorRed);
      }
    }
  }
}
