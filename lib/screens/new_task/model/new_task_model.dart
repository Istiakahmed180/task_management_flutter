class NewTaskModel {
  String? status;
  List<NewTaskData>? data;

  NewTaskModel({this.status, this.data});

  NewTaskModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <NewTaskData>[];
      json['data'].forEach((v) {
        data!.add(NewTaskData.fromJson(v));
      });
    }
  }
}

class NewTaskData {
  String? sId;
  String? title;
  String? description;
  String? status;
  String? email;
  String? createdDate;

  NewTaskData(
      {this.sId,
      this.title,
      this.description,
      this.status,
      this.email,
      this.createdDate});

  NewTaskData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    email = json['email'];
    createdDate = json['createdDate'];
  }
}
