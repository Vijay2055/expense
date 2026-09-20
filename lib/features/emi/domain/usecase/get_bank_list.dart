
import 'package:expense_app/features/emi/domain/entity/bank_entity.dart';

class GetBankList {
  List<BankEntity> call() {
    return [
      BankEntity(
        id: '1',
        name: 'State Bank of India',
        principle: 100000,
        time: 12,
        rate: 8.50,
      ),
      BankEntity(
        id: '2',
        name: 'HDFC Bank',
        principle: 100000,
        time: 12,
        rate: 8.75,
      ),
      BankEntity(
        id: '3',
        name: 'ICICI Bank',
        principle: 100000,
        time: 12,
        rate: 8.80,
      ),
      BankEntity(
        id: '4',
        name: 'Axis Bank',
        principle: 100000,
        time: 12,
        rate: 8.95,
      ),
      BankEntity(
        id: '5',
        name: 'Kotak Mahindra Bank',
        principle: 100000,
        time: 12,
        rate: 9.00,
      ),
      BankEntity(
        id: '6',
        name: 'Punjab National Bank',
        principle: 100000,
        time: 12,
        rate: 8.60,
      ),
      BankEntity(
        id: '7',
        name: 'Bank of Baroda',
        principle: 100000,
        time: 12,
        rate: 8.65,
      ),
      BankEntity(
        id: '8',
        name: 'Canara Bank',
        principle: 100000,
        time: 12,
        rate: 8.70,
      ),
      BankEntity(
        id: '9',
        name: 'Union Bank of India',
        principle: 100000,
        time: 12,
        rate: 8.75,
      ),
      BankEntity(
        id: '10',
        name: 'IDFC FIRST Bank',
        principle: 100000,
        time: 12,
        rate: 9.10,
      ),
    ];
  }
}

