class Register {
  int? idx;
  String fullname;
  String phone;
  String email;
  String image;

  Register({
    this.idx,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
  });

  factory Register.fromJson(Map<String, dynamic> json) => Register(
    idx: json["idx"],
    fullname: json["fullname"],
    phone: json["phone"],
    email: json["email"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "fullname": fullname,
    "phone": phone,
    "email": email,
    "image": image,
    if (idx != null) "idx": idx,
  };
}
