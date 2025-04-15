part of 'dashboard_bloc.dart';

sealed class DashboardEvent {}

class DashboardInitialFetchEvent extends DashboardEvent{
  
}
class DashboardDepositEvent extends DashboardEvent {
  final  TransactionsModel 
 transactionModel;
  DashboardDepositEvent({
    required this.transactionModel,
  });
}

class DashboardWithdrawEvent extends DashboardEvent {
  final TransactionsModel transactionModel;
  DashboardWithdrawEvent({
    required this.transactionModel,
  });}