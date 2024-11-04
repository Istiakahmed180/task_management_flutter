import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/app_colors.dart';

class EmailAddressScreen extends StatelessWidget {
  const EmailAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

Form _buildEmailAddressForm(
  context,
  GlobalKey<FormState> formKey,
) {
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
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, Routes.pinVerification),
          child: const Icon(
            Icons.arrow_circle_right_outlined,
            size: 30,
          ),
        ),
      ],
    ),
  );
}
