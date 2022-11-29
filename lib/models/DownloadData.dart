class DownloadData {
  int? id;
  String? description;
  String? duration;
  String? filePath;
  String? image;
  String? title;
  int? userId;

  DownloadData({this.id, this.description, this.duration, this.filePath, this.image, this.title, this.userId});

  factory DownloadData.fromJson(Map<String, dynamic> json) {
    return DownloadData(id: json['id'], description: json['description'], duration: json['duration'], filePath: json['file_path'], image: json['image'], title: json['title'], userId: json['userId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['file_path'] = this.filePath;
    data['image'] = this.image;
    data['title'] = this.title;
    data['userId'] = this.userId;
    return data;
  }
}
