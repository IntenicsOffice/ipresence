String? _TAG = "I=P Ipresence UserLoginResponse";

class UserLoginResponse {
  dynamic status;
  dynamic accessToken;
  dynamic refreshToken;
  dynamic userId;
  dynamic companyId;
  dynamic companyName;
  dynamic name;
  dynamic mobile;
  dynamic email;

  UserLoginResponse(
      {this.status,
      this.accessToken,
      this.refreshToken,
      this.userId,
      this.companyId,
      this.companyName,
      this.name,
      this.mobile,
      this.email});

  UserLoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    userId = json['_id'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['access_token'] = this.accessToken;
    data['refresh_token'] = this.refreshToken;
    data['_id'] = this.userId;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    return data;
  }
}
