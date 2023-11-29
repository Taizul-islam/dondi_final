class CategoryOfExplorer {
  int? status;
  String? message;
  List<ExplorerCategory>? data;

  CategoryOfExplorer({this.status, this.message, this.data});

  CategoryOfExplorer.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ExplorerCategory>[];
      json['data'].forEach((v) {
        data!.add(new ExplorerCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExplorerCategory {
  int? categoryId;
  String? categoryName;
  int? videosCount;

  ExplorerCategory({this.categoryId, this.categoryName, this.videosCount});

  ExplorerCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    videosCount = json['videos_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['videos_count'] = this.videosCount;
    return data;
  }
}