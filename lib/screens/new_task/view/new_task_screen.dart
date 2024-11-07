import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:task_management/common/widgets/app_background.dart';
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
  List<NewTaskData> _newTaskList = [];
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
      final NewTaskModel newTaskModel =
          NewTaskModel.fromJson(response.requestResponse);
      _newTaskList.clear();
      _newTaskList = newTaskModel.data ?? [];
      _isNewTaskListProgress = false;
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
  }

  Future<void> _goToNewTaskCreateScreen() async {
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
      floatingActionButton: BuildCreateNewTaskFlotButton(
        goToNewTaskCreateScreen: _goToNewTaskCreateScreen,
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
        child: ListView.separated(
            itemBuilder: (context, index) {
              final NewTaskData task = _newTaskList[index];
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: AppColors.colorWhite,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${task.title!.isNotEmpty ? task.title : "N/A"}",
                        style: textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${task.description!.isNotEmpty ? task.description : "N/A"}",
                        style: textTheme.titleSmall?.copyWith(
                            color: AppColors.colorLightGray,
                            fontSize: 12,
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Date : ${DateFormat("dd-MMM-yyyy").format(DateTime.parse(task.createdDate!))}",
                        style: textTheme.titleSmall?.copyWith(
                            color: AppColors.colorDarkBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.colorBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () {},
                              child: Text(
                                "${task.status!.isNotEmpty ? task.status : "N/A"}",
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.edit_off_outlined,
                                    color: AppColors.colorGreen,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.delete_forever_sharp,
                                    color: AppColors.colorRed,
                                  ))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: _newTaskList.length),
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

class BuildCreateNewTaskFlotButton extends StatelessWidget {
  final Function goToNewTaskCreateScreen;

  const BuildCreateNewTaskFlotButton({
    super.key,
    required this.goToNewTaskCreateScreen,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      onPressed: () => goToNewTaskCreateScreen(),
      backgroundColor: AppColors.colorGreen,
      child: const Icon(
        Icons.add,
        color: AppColors.colorWhite,
      ),
    );
  }
}
