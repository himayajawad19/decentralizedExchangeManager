part of 'dashboard_bloc.dart';

sealed class DashboardState {
}

class DashboardInitial extends DashboardState{
  
}
class DashboardLoadingState extends DashboardState{
  
}
class DashboardErrorState extends DashboardState{
  
}
class DashboardSuccessState extends DashboardState{
  final List<TransactionsModel> transactions;
  final int balance;

  DashboardSuccessState({required this.transactions, required this.balance});
}

class DashboardThemeState extends DashboardState{
final bool themeState;

  DashboardThemeState({required this.themeState});
}
