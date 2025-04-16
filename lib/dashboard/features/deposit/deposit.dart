import 'package:decentralized_app/dashboard/bloc/dashboard_bloc.dart';
import 'package:decentralized_app/models/transactions_model.dart';
import 'package:decentralized_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Deposit extends StatefulWidget {
    final DashboardBloc dashboardBloc;
  const Deposit({super.key,  required this.dashboardBloc});

  @override
  State<Deposit> createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  TextEditingController addressController = TextEditingController(text: "0x59FcBA3ccb1F3FA2e1Cb67eC328f8f58E80A8A0E");
  TextEditingController amountController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          title: Text(
            "Deposit Funds",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.sp),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "To deposit funds, enter your wallet address, the amount you wish to send, and an optional reason for the transaction. Make sure the address is correct before confirming your transfer.",
                ),
                SizedBox(height: 16.sp),
                Text(
                  "Address",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                ),
                TextField(
                  readOnly: true,
                  
                  controller: addressController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(border: OutlineInputBorder(), ),
                ),
                SizedBox(height: 16.sp),
                Text(
                  "Amount",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                ),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                SizedBox(height: 16.sp),
                Text(
                  "Reason",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                ),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                SizedBox(height: 16.sp),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                              widget.dashboardBloc.add(DashboardDepositEvent(
                    transactionModel: TransactionsModel(
                      address: 
                        addressController.text,
                        amount: 
                        int.parse(amountController.text),
                        reason: 
                        reasonController.text,
                        timeStamp: 
                        DateTime.now())));
                Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentColor,
                        ),
                        child: Text(
                          "Deposit",
                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
