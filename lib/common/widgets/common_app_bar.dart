import 'package:flutter/material.dart';
import 'package:task_management/common/auth_controller.dart';
import 'package:task_management/common/widgets/exit_confirmation_alert_dialog.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/constants/assets_path.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key});

  @override
  State<CommonAppBar> createState() => _CommonAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}

class _CommonAppBarState extends State<CommonAppBar> {
  final AuthController _authController = AuthController();
  Map<String, String> userInformation = {};

  @override
  void initState() {
    super.initState();
    _authController.getUserInfo().then((user) {
      setState(() {
        userInformation = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.colorGreen,
      title: ListTile(
        title: Text(
          userInformation["userName"] ?? "User Name",
          style: textTheme.titleLarge
              ?.copyWith(color: AppColors.colorWhite, fontSize: 20),
        ),
        subtitle: Text(
          userInformation["email"] ?? "user@example.com",
          style: textTheme.titleSmall?.copyWith(
            color: AppColors.colorWhite,
            fontSize: 12,
          ),
        ),
        leading: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {},
          child: const CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.colorGreen,
            backgroundImage: AssetImage(AssetsPath.avater),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _showExitConfirmationAlertDialog(context);
          },
          icon: const Icon(Icons.logout_outlined),
        ),
      ],
    );
  }

  Future<bool> _showExitConfirmationAlertDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => ExitConfirmationAlertDialog(
        title: "Logout Application?",
        content: "Are you sure you want to logout of the application?",
        actionYes: () {
          _authController.clearSharedPreferenceData();
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.signIn,
            (route) => false,
          );
        },
      ),
    ).then((value) => value ?? false);
  }
}
