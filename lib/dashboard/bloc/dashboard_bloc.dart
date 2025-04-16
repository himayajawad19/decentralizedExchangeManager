import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:decentralized_app/models/transactions_model.dart';
import 'package:decentralized_app/utils/app_constant.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardInitialFetchEvent>(dashboardInitialFetchEvent);
    on<DashboardDepositEvent>(dashboardDepositEvent);
    on<DashboardWithdrawEvent>(dashboardWithdrawEvent);

  }

  List<TransactionsModel> transactions = [];
  Web3Client? _web3client;
  late ContractAbi _abiCode;
  late EthPrivateKey _cred;
  int balance = 0;

  late DeployedContract _deployedContract;
  late ContractFunction _deposit;
  late ContractFunction _withdraw;
  late ContractFunction _getBalance;
  late ContractFunction _getAllTransactions;

  FutureOr<void> dashboardInitialFetchEvent(
    DashboardInitialFetchEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoadingState());
    await Future.delayed(Duration(milliseconds: 2000));
    try {
      final String rpcUrl = 'http://10.0.2.2:7545';
      final String socketUrl = 'ws://10.0.2.2:7545';
      final String privateKey =
          '0x348e349c06e01599856c0860cd31062c6b8da61709a4433457e68345bd0ba40e';

      _web3client = await Web3Client(
        rpcUrl,
        http.Client(),
        socketConnector: () {
          return IOWebSocketChannel.connect(socketUrl).cast<String>();
        },
      );

      String abiFile = await rootBundle.loadString(
        'build/contracts/ExpenseManagerContract.json',
      );
      var jsonDecoded = jsonDecode(abiFile);
      _abiCode = ContractAbi.fromJson(
        jsonEncode(jsonDecoded['abi']),
        "ExpenseManagerContract",
      );
      log(_abiCode.toString());
      _cred = EthPrivateKey.fromHex(privateKey);

      var contractAddress = EthereumAddress.fromHex(
        "0x923c2D85a3892bcF5f850D542D54436b9394Ea13",
      );

      _deployedContract = DeployedContract(_abiCode, contractAddress);
      _deposit = _deployedContract.function("deposit");
      _withdraw = _deployedContract.function("withdraw");
      _getBalance = _deployedContract.function("getBalance");
      _getAllTransactions = _deployedContract.function("getAllTransactions");

      final transactionsData = await _web3client!.call(
        contract: _deployedContract,
        function: _getAllTransactions,
        params: [],
      );
      log("Transactions Data: $transactionsData");

      final balanceData = await _web3client!.call(
        contract: _deployedContract,
        function: _getBalance,
        params: [
          _cred.address,
        ],
      );
      log("Balance Data: $balanceData");

      List<TransactionsModel> trans = [];
      for (int i = 0; i < transactionsData[0].length; i++) {
        TransactionsModel transactionModel = TransactionsModel(
          address: transactionsData[0][i].toString(),
          amount: transactionsData[1][i].toInt(),
          reason: transactionsData[2][i].toString(), // change if needed
          timeStamp: DateTime.fromMicrosecondsSinceEpoch(
            transactionsData[3][i].toInt(),
          ),
        );
        trans.add(transactionModel);
      }
      transactions = trans;

      balance = balanceData[0].toInt();

      emit(DashboardSuccessState(transactions: transactions, balance: balance));
    } catch (e, st) {
      log("Error in dashboardInitialFetchEvent: $e\n$st");
      // emit(DashboardErrorState(errorMessage: e.toString()));
    }
  }

 FutureOr<void> dashboardDepositEvent(
      DashboardDepositEvent event, Emitter<DashboardState> emit) async {
        await Future.delayed(Duration(milliseconds: 2000));
    try {
      final transaction =  Transaction.callContract(
          from: EthereumAddress.fromHex(
              "0x59FcBA3ccb1F3FA2e1Cb67eC328f8f58E80A8A0E"),
          contract: _deployedContract,
          function: _deposit,
          parameters: [
            BigInt.from(event.transactionModel.amount),
            event.transactionModel.reason
          ],
          value: EtherAmount.inWei(BigInt.from(event.transactionModel.amount)));

      final result = await _web3client!.sendTransaction(_cred, transaction,
          chainId: 1337, fetchChainIdFromNetworkId: false);
      log(result.toString());
      add(DashboardInitialFetchEvent());
    } catch (e) {
      log(e.toString());
    }
  }


  FutureOr<void> dashboardWithdrawEvent(
      DashboardWithdrawEvent event, Emitter<DashboardState> emit) async {
        
    try {
      final transaction = Transaction.callContract(
        from: EthereumAddress.fromHex(
            "0x59FcBA3ccb1F3FA2e1Cb67eC328f8f58E80A8A0E"),
        contract: _deployedContract,
        function: _withdraw,
        parameters: [
          BigInt.from(event.transactionModel.amount),
          event.transactionModel.reason
        ],
      );

      final result = await _web3client!.sendTransaction(_cred, transaction,
          chainId: 1337, fetchChainIdFromNetworkId: false);
      log(result.toString());
      add(DashboardInitialFetchEvent());
    } catch (e) {
      log(e.toString());
    }
  }

 
}
