import 'package:flutter/material.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/common/widgets/common_app_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CommonAppBar(),
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Text(
                  "Update Profile",
                  style: textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _buildProfileUpdateForm(context, formKey),
                Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildProfileUpdateForm(
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
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: TextEditingController(),
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
          controller: TextEditingController(),
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
          controller: TextEditingController(),
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(hintText: "Mobile"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter mobile number";
            }
            return null;
          },
        ),
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
          },
        ),
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
