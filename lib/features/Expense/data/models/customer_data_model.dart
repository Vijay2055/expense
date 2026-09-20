class CustomerModel {
  final String id;
  final String? mobile;
  final String name;
  final String? address;
  

  CustomerModel(
      {required this.id, this.mobile, required this.name, this.address});

  Map<String, dynamic> toJson() {
    return {
      "id":id,
      "mobile":mobile,
      "name":name,
      "address":address
    };
  }
}
