class UserPlan {
  List<Subscription>? subscriptions;

  UserPlan({this.subscriptions});

  factory UserPlan.fromJson(Map<String, dynamic> json) {
    return UserPlan(
      subscriptions: json['subscriptions'] != null ? (json['subscriptions'] as List).map((i) => Subscription.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subscriptions != null) {
      data['subscriptions'] = this.subscriptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subscription {
  String? subscription_plan_id;
  String? start_date;
  String? expiration_date;
  String? status;
  String? trail_status;
  String? subscription_plan_name;
  String? billing_amount;
  String? trial_end;

  Subscription({
    this.subscription_plan_id,
    this.start_date,
    this.expiration_date,
    this.status,
    this.trail_status,
    this.subscription_plan_name,
    this.billing_amount,
    this.trial_end,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      subscription_plan_id: json['subscription_plan_id'],
      start_date: json['start_date'],
      expiration_date: json['expiration_date'],
      status: json['status'],
      trail_status: json['trail_status'],
      subscription_plan_name: json['subscription_plan_name'],
      billing_amount: json['billing_amount'],
      trial_end: json['trial_end'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscription_plan_id'] = this.subscription_plan_id;
    data['start_date'] = this.start_date;
    data['expiration_date'] = this.expiration_date;
    data['status'] = this.status;
    data['trail_status'] = this.trail_status;
    data['subscription_plan_name'] = this.subscription_plan_name;
    data['billing_amount'] = this.billing_amount;
    data['trial_end'] = this.trial_end;
    return data;
  }
}
