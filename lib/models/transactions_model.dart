class TransactionsModel {
  final String address;
  final DateTime timeStamp;
  final String reason;
  final int amount;

  TransactionsModel({required this.address, required this.timeStamp, required this.reason, required this.amount});
}
