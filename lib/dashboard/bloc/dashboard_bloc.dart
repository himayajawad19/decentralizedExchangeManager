import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:decentralized_app/models/transactions_model.dart';
import 'package:flutter/foundation.dart';
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

  late DeployedContract _deployedContract;
  late ContractFunction _deposit;
  late ContractFunction _withdraw;
  late ContractFunction _getTransaction;
  late ContractFunction _getAllTransactions;
  FutureOr<void> dashboardInitialFetchEvent(
    DashboardInitialFetchEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoadingState());
    final String rpcUrl = 'http://10.0.2.2:7545';
    final String socketUrl = 'ws://10.0.2.2:7545';
    final String privateKey =
        '0x4b57d9e210f1b9b7f6c9c0a60195a0312fa3755baa9b38a79ef69eef8b064755';
    _web3client = Web3Client(
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
    _cred = EthPrivateKey.fromHex(privateKey);
    var address = _cred.address;
    var _contractAddress = EthereumAddress.fromHex(
      "0x923c2D85a3892bcF5f850D542D54436b9394Ea13",
    );
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _deposit = _deployedContract.function("deposit");
    _withdraw = _deployedContract.function("withdraw");
    _getTransaction = _deployedContract.function("getBalance");
    _getAllTransactions = _deployedContract.function("getAllTransactions");

    final data = _web3client!.call(
      contract: _deployedContract,
      function: _getAllTransactions,
      params: [],
    );
    log(data.toString());
  }

  FutureOr<void> dashboardDepositEvent(DashboardDepositEvent event, Emitter<DashboardState> emit) {
      final data = _web3client!.call(
      contract: _deployedContract,
      function: _deposit,
      params: [event.transactionModel.amount, event.transactionModel.reason],
    );
  }

  FutureOr<void> dashboardWithdrawEvent(DashboardWithdrawEvent event, Emitter<DashboardState> emit) {
      final data = _web3client!.call(
      contract: _deployedContract,
      function: _withdraw,
      params: [event.transactionModel.amount, event.transactionModel.reason],
    );
  }
}
