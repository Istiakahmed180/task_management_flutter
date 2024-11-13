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
import 'package:task_management/screens/forgot_password/view/pin_verification_screen.dart';

class EmailAddressScreen extends StatefulWidget {
  const EmailAddressScreen({super.key});

  @override
  State<EmailAddressScreen> createState() => _EmailAddressScreenState();
}

class _EmailAddressScreenState extends State<EmailAddressScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool isEmailVerification = false;
  bool isProgress = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      isEmailVerification = formKey.currentState?.validate() ?? false;
    });
  }

  void disposeTextFields() {
    _emailController.dispose();
  }

  Future<void> emailVerification() async {
    if (formKey.currentState!.validate()) {
      isProgress = true;
      setState(() {});
      final email = _emailController.text.trim();

      final NetworkResponse response = await NetworkService.getRequest(
          context: context, url: ApiPath.emailAddressVerify(email));
      isProgress = false;
      setState(() {});
      if (response.isSuccess) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PinVerificationScreen(email: email),
            ));
        Fluttertoast.showToast(
            msg: response.requestResponse["data"],
            backgroundColor: AppColors.colorGreen);
      } else {
        Fluttertoast.showToast(
            msg: response.errorMessage, backgroundColor: AppColors.colorRed);
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
                Text(
                  "Your Email Address",
                  style: textTheme.displaySmall,
                ),
                const SizedBox(height: 20),
                Text(
                  "A 6 digit verification pin will send to your email address",
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: 24),
                _buildEmailAddressForm(context, formKey),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      _buildSignInSection(context),
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

  Form _buildEmailAddressForm(
    context,
    GlobalKey<FormState> formKey,
  ) {
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
          ElevatedButton(
            onPressed: isEmailVerification ? emailVerification : null,
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
}

RichText _buildSignInSection(
  context,
) {
  return RichText(
    text: TextSpan(
      style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.5),
      text: "Have account? ",
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
