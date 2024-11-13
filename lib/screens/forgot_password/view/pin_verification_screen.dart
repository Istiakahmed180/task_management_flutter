import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/api_path.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/network/network_response.dart';
import 'package:task_management/network/network_service.dart';
import 'package:task_management/screens/forgot_password/view/set_password_screen.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  String otp = "";
  bool isProgress = false;
  bool isPinVerified = false;

  void _validatePinVerified() {
    setState(() {
      isPinVerified = otp.isNotEmpty && otp.length == 6;
    });
  }

  Future<void> otpVerify() async {
    setState(() {
      isProgress = true;
    });

    final NetworkResponse response = await NetworkService.getRequest(
      context: context,
      url: ApiPath.pinCodeVerify(widget.email, otp),
    );

    setState(() {
      isProgress = false;
    });

    if (response.isSuccess) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SetPasswordScreen(email: widget.email, otp: otp),
          ));
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
                  "Pin Verification",
                  style: textTheme.displaySmall,
                ),
                const SizedBox(height: 20),
                Text(
                  "A 6 digit verification pin will be sent to your email address",
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: 24),
                _buildPinCodeVerify(),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      _buildSignInSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinCodeVerify() {
    return Column(
      children: [
        PinCodeTextField(
          backgroundColor: Colors.transparent,
          appContext: context,
          length: 6,
          cursorColor: AppColors.colorLightGray,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8),
            fieldHeight: 50,
            fieldWidth: 40,
            activeColor: AppColors.colorWhite,
            inactiveColor: AppColors.colorGreen,
            inactiveFillColor: AppColors.colorWhite,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              otp = value;
              _validatePinVerified();
            });
          },
        ),
        ElevatedButton(
          onPressed: isPinVerified && !isProgress ? otpVerify : null,
          child: isProgress
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.colorWhite,
                  ),
                )
              : const Text("Verify"),
        ),
      ],
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
