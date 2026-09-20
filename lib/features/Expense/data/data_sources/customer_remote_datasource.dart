import 'package:expense_app/features/Expense/data/models/customer_data_model.dart';

abstract class CustomerRemoteDataSource {
  Future<List<CustomerModel>> getCustomers();

  Future<CustomerModel?> getCustomerById(String id);

  Future<void> addCustomer(CustomerModel customer);

  Future<void> updateCustomer(CustomerModel customer);

  Future<void> deleteCustomer(String id);
}



class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  const CustomerRemoteDataSourceImpl();

  @override
  Future<List<CustomerModel>> getCustomers() async {
    // TODO: Implement Firebase Firestore
    return [];
  }

  @override
  Future<CustomerModel?> getCustomerById(String id) async {
    // TODO: Implement Firebase Firestore
    return null;
  }

  @override
  Future<void> addCustomer(CustomerModel customer) async {
    // TODO: Implement Firebase Firestore
  }

  @override
  Future<void> updateCustomer(CustomerModel customer) async {
    // TODO: Implement Firebase Firestore
  }

  @override
  Future<void> deleteCustomer(String id) async {
    // TODO: Implement Firebase Firestore
  }
}