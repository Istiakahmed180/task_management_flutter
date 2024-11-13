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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isSignUp = false;
  bool isProgress = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _firstNameController.addListener(_validateForm);
    _lastNameController.addListener(_validateForm);
    _phoneNumberController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      isSignUp = formKey.currentState?.validate() ?? false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    disposeTextFields();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return AppBackground(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    "Join With Us",
                    style: textTheme.displaySmall,
                  ),
                  const SizedBox(height: 24),
                  _buildSignUpForm(context),
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        _buildSignInSection(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInSection(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.5),
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
                    )),
        ],
      ),
    );
  }

  Widget _buildSignUpForm(BuildContext context) {
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
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _firstNameController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(hintText: "First Name"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter first name";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _lastNameController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(hintText: "Last Name"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter last name";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: "Mobile"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter mobile number";
              } else if (!RegExp(RegularExpression.phone).hasMatch(value)) {
                return "Invalid phone number format";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: "Password"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter password";
              } else if (!RegExp(RegularExpression.password).hasMatch(value)) {
                return "At least 8 characters and both letters and numbers";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isSignUp ? signUp : null,
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

  Future<void> signUp() async {
    if (formKey.currentState!.validate()) {
      isProgress = true;
      setState(() {});
      final email = _emailController.text.trim();
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final phoneNumber = _phoneNumberController.text.trim();
      final password = _passwordController.text;

      final Map<String, String> requestBody = {
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": phoneNumber,
        "password": password,
      };

      final NetworkResponse response = await NetworkService.postRequest(
          context: context,
          url: ApiPath.registration,
          requestBody: requestBody);
      isProgress = false;
      setState(() {});
      if (response.isSuccess) {
        Navigator.pushReplacementNamed(context, Routes.signIn);
        clearTextFields();
        Fluttertoast.showToast(
            msg: "Registration Complete",
            backgroundColor: AppColors.colorGreen);
      } else {
        Fluttertoast.showToast(
            msg: response.errorMessage, backgroundColor: AppColors.colorRed);
      }
    }
  }

  void disposeTextFields() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
  }

  void clearTextFields() {
    _emailController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _phoneNumberController.clear();
    _passwordController.clear();
  }
}
