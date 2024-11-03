import 'package:flutter/material.dart';
import 'package:task_management/common/widgets/exit_confirmation_alert_dialog.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.colorGreen,
      title: ListTile(
        title: Text(
          "userName",
          style: textTheme.titleLarge
              ?.copyWith(color: AppColors.colorWhite, fontSize: 20),
        ),
        subtitle: Text(
          "userEmail",
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
        actionYes: () {},
      ),
    ).then((value) => value ?? false);
  }
}
