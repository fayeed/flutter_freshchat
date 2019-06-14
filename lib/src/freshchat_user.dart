part of firebase_auth;

class FreshchatUser {
  String id;
  String email;
  String referenceId;
  DateTime createdTime;
  String phone;
  String firstName;
  String lastName;
  String phoneCountryCode;

  FreshchatUser.initail()
      : id = "",
        email = "",
        referenceId = "",
        createdTime = DateTime.now(),
        phone = "",
        firstName = "",
        lastName = "",
        phoneCountryCode = "";

  FreshchatUser.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    email = json["email"];
    referenceId = json["reference_id"];
    firstName = json["first_name"];
    lastName = json["last_name"];
    phone = json["phone"];
    createdTime = DateTime.parse(json["createdTime"]);
    phoneCountryCode = json["phone_country_code"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = Map<String, dynamic>();

    result['id'] = id;
    result['email'] = email;
    result['first_name'] = firstName;
    result['last_name'] = lastName;
    result['phone'] = phone;
    result['reference_id'] = referenceId;
    result['created_time'] = createdTime.toString();
    result['phone_country_code'] = phoneCountryCode;

    return result;
  }
}
