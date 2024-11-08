import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/common/widgets/common_floatin_action_button.dart';
import 'package:task_management/common/widgets/common_task_card.dart';
import 'package:task_management/common/widgets/not_found.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/api_path.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/network/network_response.dart';
import 'package:task_management/network/network_service.dart';
import 'package:task_management/screens/new_task/model/new_task_model.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  List<TaskData> _newTaskList = [];
  bool _isNewTaskListProgress = false;

  @override
  void initState() {
    super.initState();
    _getNewTaskList();
  }

  Future<void> _getNewTaskList() async {
    _isNewTaskListProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkService.getRequest(
        context: context, url: ApiPath.newTaskList);
    if (response.isSuccess) {
      final TaskModel newTaskModel =
          TaskModel.fromJson(response.requestResponse);
      _newTaskList.clear();
      _newTaskList = newTaskModel.data ?? [];
      _isNewTaskListProgress = false;
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorGreen);
    }
  }

  Future<void> _deleteNewTaskList(String taskId) async {
    _isNewTaskListProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkService.getRequest(
        context: context, url: ApiPath.deleteTask(taskId));
    if (response.isSuccess) {
      Fluttertoast.showToast(
          msg: "Task Delete Complete", backgroundColor: AppColors.colorGreen);
      _getNewTaskList();
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
    _isNewTaskListProgress = false;
    setState(() {});
  }

  Future<void> _updateNewTaskList(String taskId, String status) async {
    _isNewTaskListProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkService.getRequest(
        context: context, url: ApiPath.updateTask(taskId, status));
    if (response.isSuccess) {
      Fluttertoast.showToast(
          msg: "Task Update Complete", backgroundColor: AppColors.colorGreen);
      _getNewTaskList();
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
    _isNewTaskListProgress = false;
    setState(() {});
  }

  Future<void> _goToTaskCreateScreen() async {
    final result = await Navigator.pushNamed(context, Routes.createNewTask);
    if (result == true) {
      _getNewTaskList();
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: AppBackground(
          child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildProgressHeaderSection(textTheme),
            const SizedBox(
              height: 10,
            ),
            _buildTaskListSection(textTheme)
          ],
        ),
      )),
      floatingActionButton: CommonFloatingActionButton(
        goToTaskCreateScreen: _goToTaskCreateScreen,
      ),
    );
  }

  Widget _buildTaskListSection(TextTheme textTheme) {
    return Visibility(
      visible: !_isNewTaskListProgress,
      replacement: const Expanded(
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: AppColors.colorGreen,
          ),
        ),
      ),
      child: Expanded(
        child: _newTaskList.isEmpty
            ? const NotFound(title: "New Task List Not Found")
            : CommonTaskCard(
                taskList: _newTaskList,
                textTheme: textTheme,
                onDelete: _deleteNewTaskList,
                onUpdate: _updateNewTaskList,
              ),
      ),
    );
  }

  Row _buildProgressHeaderSection(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildProgressSection(
            textTheme: textTheme,
            progressCount: "09",
            progressName: "New Task"),
        const SizedBox(
          width: 5,
        ),
        _buildProgressSection(
            textTheme: textTheme,
            progressCount: "09",
            progressName: "Completed"),
        const SizedBox(
          width: 5,
        ),
        _buildProgressSection(
            textTheme: textTheme,
            progressCount: "09",
            progressName: "Canceled"),
        const SizedBox(
          width: 5,
        ),
        _buildProgressSection(
            textTheme: textTheme, progressCount: "09", progressName: "Progress")
      ],
    );
  }

  Expanded _buildProgressSection(
      {required TextTheme textTheme,
      required String progressCount,
      required String progressName}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: AppColors.colorWhite,
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              progressCount,
              style:
                  textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              progressName,
              style: textTheme.titleSmall?.copyWith(
                  color: AppColors.colorLightGray,
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
