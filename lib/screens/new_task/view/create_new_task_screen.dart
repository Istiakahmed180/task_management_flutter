import 'package:flutter/material.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/common/widgets/common_app_bar.dart';

class CreateNewTaskScreen extends StatefulWidget {
  const CreateNewTaskScreen({super.key});

  @override
  State<CreateNewTaskScreen> createState() => _CreateNewTaskScreenState();
}

class _CreateNewTaskScreenState extends State<CreateNewTaskScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CommonAppBar(),
      body: AppBackground(
        child: SingleChildScrollView(
          reverse: true,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Text(
                "Add New Task",
                style:
                    textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _buildNewTaskForm(context, formKey),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom))
            ],
          ),
        ),
      ),
    );
  }

  Form _buildNewTaskForm(context, GlobalKey<FormState> formKey) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: TextEditingController(),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(hintText: "Title"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter title";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: TextEditingController(),
            maxLines: 5,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              hintText: "Description",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter description";
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
}
