class LikeAndWatchListResponse {
  String? message;
  bool? isAdded;

  LikeAndWatchListResponse({this.message, this.isAdded});

  factory LikeAndWatchListResponse.fromJson(Map<String, dynamic> json) {
    return LikeAndWatchListResponse(
      message: json['message'],
      isAdded: json['is_added'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['wathclist'] = this.isAdded;
    return data;
  }
}
