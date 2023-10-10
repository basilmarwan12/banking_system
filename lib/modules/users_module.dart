import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class User {
  String firstName;
  String lastName;
  int? userId;
  double userBalance;

  User(
      {this.userId,
      required this.firstName,
      required this.lastName,
      required this.userBalance});
  factory User.fromJson(Map<String, dynamic> json) => User(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      userBalance: json['balance'] as double,
      userId: json['userId'] as int);

  static List<User> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => User.fromJson(json)).toList();
  }
}
