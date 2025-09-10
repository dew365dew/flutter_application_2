// To parse this JSON data, do
//
//     final customerIdxGetRes = customerIdxGetResFromJson(jsonString);

import 'dart:convert';

CustomerIdxGetRes customerIdxGetResFromJson(String str) =>
    CustomerIdxGetRes.fromJson(json.decode(str));

String customerIdxGetResToJson(CustomerIdxGetRes data) =>
    json.encode(data.toJson());

class CustomerIdxGetRes {
  Customer customer;

  CustomerIdxGetRes({required this.customer});

  factory CustomerIdxGetRes.fromJson(Map<String, dynamic> json) =>
      CustomerIdxGetRes(customer: Customer.fromJson(json["customer"]));

  Map<String, dynamic> toJson() => {"customer": customer.toJson()};
}

class Customer {
  int idx;
  String fullname;
  String phone;
  String email;
  String image;

  Customer({
    required this.idx,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    idx: json["idx"],
    fullname: json["fullname"],
    phone: json["phone"],
    email: json["email"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "idx": idx,
    "fullname": fullname,
    "phone": phone,
    "email": email,
    "image": image,
  };
}
