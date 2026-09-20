class CustomerEntity {
  final String id;
  final String name;
  final String? mobile;
  final String? address;

  CustomerEntity(
      {required this.id,
      required this.name,
       this.mobile,
      this.address});
}
