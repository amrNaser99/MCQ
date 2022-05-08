class UserModel {
  late String? uId ;
  late String? userName ;
  late String? email ;
  late String? phone ;
  late bool? isEmailVerified ;

  UserModel({
      this.userName,
      this.email,
      this.phone,
      this.uId,
      this.isEmailVerified });

  UserModel.fromJson(Map<String,dynamic> json)
  {
    userName = json['userName'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String,dynamic> toMap()
  {
    return {
      'userName':userName,
      'email':email,
      'phone':phone,
      'uId':uId,
      'isEmailVerified':isEmailVerified,
    };
  }

}