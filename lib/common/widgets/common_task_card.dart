import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/screens/new_task/model/new_task_model.dart';

class CommonTaskCard extends StatelessWidget {
  const CommonTaskCard({
    super.key,
    required this.taskList,
    required this.textTheme,
    required this.onDelete,
  });

  final List<TaskData> taskList;
  final TextTheme textTheme;
  final Function(String taskId) onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          final TaskData task = taskList[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                  const SizedBox(height: 10),
                  Text(
                    "${task.description!.isNotEmpty ? task.description : "N/A"}",
                    style: textTheme.titleSmall?.copyWith(
                        color: AppColors.colorLightGray,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Date : ${DateFormat("dd-MMM-yyyy").format(DateTime.parse(task.createdDate!))}",
                    style: textTheme.titleSmall?.copyWith(
                        color: AppColors.colorDarkBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 110,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.colorBlue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            visualDensity: VisualDensity.compact,
                          ),
                          onPressed: () {},
                          child: Text(
                              "${task.status!.isNotEmpty ? task.status : "N/A"}"),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed:
                                () {}, // Add edit functionality here if needed
                            icon: const Icon(Icons.edit_off_outlined,
                                color: AppColors.colorGreen),
                          ),
                          IconButton(
                            onPressed: () => onDelete(
                                task.sId!), // Pass task ID to delete callback
                            icon: const Icon(Icons.delete_forever_sharp,
                                color: AppColors.colorRed),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
        itemCount: taskList.length);
  }
}
