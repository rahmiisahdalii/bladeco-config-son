class User {
  String? fullName;
  String? email;
  String? password;

  User({
    this.fullName,
    this.email,
    this.password,
  });

  User.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['password'] = this.password;

    return data;
  }
}
