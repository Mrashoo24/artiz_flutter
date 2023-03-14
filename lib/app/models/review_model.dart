class Review {
  String id;
  String review;
  String rate;
  String userId;
  String eServiceId;
  String createdAt;

  Review(
      {this.id,
        this.review,
        this.rate,
        this.userId,
        this.eServiceId,
        this.createdAt});

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    review = json['review'];
    rate = json['rate'];
    userId = json['user_id'];
    eServiceId = json['e_service_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['review'] = this.review;
    data['rate'] = this.rate;
    data['user_id'] = this.userId;
    data['e_service_id'] = this.eServiceId;
    data['created_at'] = this.createdAt;
    return data;
  }
}